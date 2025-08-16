#!/usr/bin/env python3
"""
Simple GUI for TourGuide to QuestShell Converter
Double-click to run, then use buttons to select files.
"""

import tkinter as tk
from tkinter import filedialog, messagebox, scrolledtext
import os
import sys
import threading

# Import your main converter (assumes tourguide_converter.py is in same directory)
try:
    from tourguide_converter import TourGuideConverter
except ImportError:
    messagebox.showerror("Error", "tourguide_converter.py not found!\nMake sure both files are in the same folder.")
    sys.exit(1)

class ConverterGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("TourGuide to QuestShell Converter")
        self.root.geometry("700x600")
        
        # Main frame
        main_frame = tk.Frame(root, padx=20, pady=20)
        main_frame.pack(fill=tk.BOTH, expand=True)
        
        # Title
        title_label = tk.Label(main_frame, text="🔄 TourGuide to QuestShell Converter", 
                              font=("Arial", 18, "bold"), fg="#2196F3")
        title_label.pack(pady=(0, 20))
        
        # Instructions
        instructions = tk.Label(main_frame, 
                               text="Choose an option below to convert your TourGuide .lua files to QuestShell format:",
                               font=("Arial", 11), fg="#666666")
        instructions.pack(pady=(0, 20))
        
        # Button frame
        button_frame = tk.Frame(main_frame)
        button_frame.pack(pady=(0, 20))
        
        # Convert single file button
        single_btn = tk.Button(button_frame, text="📄 Convert Single File", 
                              command=self.convert_single_file,
                              font=("Arial", 12, "bold"), bg="#4CAF50", fg="white",
                              height=2, width=20, relief="raised", bd=3)
        single_btn.pack(side=tk.LEFT, padx=10)
        
        # Convert multiple files button
        batch_btn = tk.Button(button_frame, text="📁 Convert All Files in Folder", 
                             command=self.convert_batch,
                             font=("Arial", 12, "bold"), bg="#2196F3", fg="white", 
                             height=2, width=20, relief="raised", bd=3)
        batch_btn.pack(side=tk.LEFT, padx=10)
        
        # Progress/Output area
        output_label = tk.Label(main_frame, text="📋 Conversion Output:", 
                               font=("Arial", 12, "bold"), fg="#333333")
        output_label.pack(anchor="w", pady=(20, 5))
        
        # Output text with better styling
        self.output_text = scrolledtext.ScrolledText(
            main_frame, 
            height=20, 
            width=80,
            font=("Consolas", 10),
            bg="#f8f9fa",
            fg="#333333",
            insertbackground="#333333"
        )
        self.output_text.pack(fill=tk.BOTH, expand=True, pady=(0, 10))
        
        # Bottom button frame
        bottom_frame = tk.Frame(main_frame)
        bottom_frame.pack(fill=tk.X)
        
        # Clear button
        clear_btn = tk.Button(bottom_frame, text="🗑️ Clear Output", 
                             command=self.clear_output,
                             font=("Arial", 10), bg="#ff6b6b", fg="white")
        clear_btn.pack(side=tk.LEFT)
        
        # Help button
        help_btn = tk.Button(bottom_frame, text="❓ Help", 
                            command=self.show_help,
                            font=("Arial", 10), bg="#ffd93d", fg="#333333")
        help_btn.pack(side=tk.RIGHT)
        
        self.log("🚀 Ready! Choose an option above to start converting.")
        self.log("💡 TIP: For all 40 files, use 'Convert All Files in Folder'")
        self.log("=" * 60)
        
    def log(self, message):
        """Add message to output area with timestamp"""
        from datetime import datetime
        timestamp = datetime.now().strftime("%H:%M:%S")
        self.output_text.insert(tk.END, f"[{timestamp}] {message}\n")
        self.output_text.see(tk.END)
        self.root.update()
        
    def clear_output(self):
        """Clear the output area"""
        self.output_text.delete(1.0, tk.END)
        self.log("🧹 Output cleared")
        
    def show_help(self):
        """Show help dialog"""
        help_text = """🔄 TourGuide to QuestShell Converter Help

📄 CONVERT SINGLE FILE:
• Click to select one .lua file
• Converts just that file
• Good for testing

📁 CONVERT ALL FILES IN FOLDER:
• Click to select a folder
• Converts ALL .lua files in that folder
• Perfect for your 40 TourGuide files!

📋 OUTPUT FILES:
For each converted file, you get:
• QS_<input-stem>.lua (QuestShell format)
• QS_<input-stem>_README.md (conversion report)

⚠️ REQUIREMENTS:
• Both .py files must be in same folder
• Python must be installed
• .lua files must be TourGuide format

🎯 RECOMMENDED:
Put all 40 TourGuide files in one folder, then use 
'Convert All Files in Folder' to convert them all at once!
"""
        messagebox.showinfo("Help", help_text)
        
    def convert_single_file(self):
        """Convert a single file"""
        file_path = filedialog.askopenfilename(
            title="Select TourGuide .lua file to convert",
            filetypes=[("Lua files", "*.lua"), ("All files", "*.*")],
            initialdir=os.getcwd()
        )
        
        if not file_path:
            self.log("❌ No file selected")
            return
            
        self.log(f"🔄 Converting: {os.path.basename(file_path)}")
        self.log("⏳ Please wait...")
        
        # Run conversion in thread to prevent GUI freezing
        threading.Thread(target=self._convert_single_worker, args=(file_path,), daemon=True).start()
        
    def _convert_single_worker(self, file_path):
        """Worker thread for single file conversion"""
        try:
            converter = TourGuideConverter()
            # Build QS_<stem>.lua output path and let converter use it
            base = os.path.basename(file_path)
            stem, ext = os.path.splitext(base)
            out_stem = f"QS_{stem}"
            output_file = os.path.join(os.path.dirname(file_path), f"{out_stem}{ext}")
            
            # guide_name can be None; converter derives and prefixes internally if needed
            output_file, readme_file = converter.convert_guide(file_path, output_file, None)
            
            self.log(f"✅ SUCCESS! Converted {os.path.basename(file_path)}")
            self.log(f"📄 Output: {os.path.basename(output_file)}")
            self.log(f"📋 README: {os.path.basename(readme_file)}")
            self.log(f"📊 Stats: {converter.stats['converted_steps']} steps converted, {converter.stats['issues_found']} issues found")
            
            if converter.stats['issues_found'] > 0:
                self.log(f"⚠️  Check the README file for manual fixes needed")
            
            self.log("─" * 60)
            
        except Exception as e:
            self.log(f"❌ ERROR: {str(e)}")
            self.log("💡 Make sure the file is in TourGuide format")
            
    def convert_batch(self):
        """Convert all files in a folder"""
        folder_path = filedialog.askdirectory(
            title="Select folder containing TourGuide .lua files",
            initialdir=os.getcwd()
        )
        
        if not folder_path:
            self.log("❌ No folder selected")
            return
            
        # Find all .lua files
        lua_files = [f for f in os.listdir(folder_path) if f.endswith('.lua')]
        
        if not lua_files:
            self.log("❌ No .lua files found in selected folder!")
            messagebox.showwarning("No Files", "No .lua files found in selected folder!")
            return
            
        self.log(f"🔍 Found {len(lua_files)} .lua files to convert")
        self.log(f"📁 Folder: {folder_path}")
        self.log("🚀 Starting batch conversion...")
        self.log("=" * 60)
        
        # Run batch conversion in thread
        threading.Thread(target=self._convert_batch_worker, args=(folder_path, lua_files), daemon=True).start()
        
    def _convert_batch_worker(self, folder_path, lua_files):
        """Worker thread for batch conversion"""
        successful = 0
        failed = 0
        total_steps = 0
        total_issues = 0
        
        for i, lua_file in enumerate(lua_files, 1):
            file_path = os.path.join(folder_path, lua_file)
            self.log(f"🔄 [{i:2d}/{len(lua_files)}] {lua_file}")
            
            try:
                converter = TourGuideConverter()
                # Build QS_<stem>.lua output path
                stem, ext = os.path.splitext(lua_file)
                out_stem = f"QS_{stem}"
                output_file = os.path.join(folder_path, f"{out_stem}{ext}")
                
                output_file, readme_file = converter.convert_guide(file_path, output_file, None)
                
                steps = converter.stats['converted_steps']
                issues = converter.stats['issues_found']
                total_steps += steps
                total_issues += issues
                
                status = "✅" if issues == 0 else "⚠️"
                self.log(f"        {status} {steps} steps, {issues} issues → {os.path.basename(output_file)}")
                successful += 1
                
            except Exception as e:
                self.log(f"        ❌ FAILED: {str(e)}")
                failed += 1
                
        # Final summary
        self.log("=" * 60)
        self.log(f"🎉 BATCH CONVERSION COMPLETE!")
        self.log(f"✅ Successful: {successful} files")
        self.log(f"❌ Failed: {failed} files")
        self.log(f"📊 Total: {total_steps} steps converted")
        self.log(f"⚠️  Total: {total_issues} issues found")
        self.log(f"📁 Output location: {folder_path}")
        
        if total_issues > 0:
            self.log(f"💡 Check individual README files for manual fixes needed")
        
        self.log("=" * 60)
        
        # Show completion dialog
        messagebox.showinfo(
            "Conversion Complete!", 
            f"Successfully converted {successful} files!\n\n"
            f"Total steps: {total_steps}\n"
            f"Total issues: {total_issues}\n\n"
            f"Check the output folder for your converted files."
        )

def main():
    # Create and configure the main window
    root = tk.Tk()
    
    # Set window icon if available (optional)
    try:
        root.iconbitmap("icon.ico")  # You can skip this if you don't have an icon
    except:
        pass
    
    # Create the GUI
    app = ConverterGUI(root)
    
    # Center the window on screen
    root.update_idletasks()
    x = (root.winfo_screenwidth() // 2) - (root.winfo_width() // 2)
    y = (root.winfo_screenheight() // 2) - (root.winfo_height() // 2)
    root.geometry(f"+{x}+{y}")
    
    # Start the GUI
    root.mainloop()

if __name__ == "__main__":
    main()
