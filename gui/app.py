# nlp_app.py
import tkinter as tk
from tkinter import ttk, messagebox, filedialog
import nltk
from nltk.sentiment import SentimentIntensityAnalyzer
from nltk import ne_chunk, pos_tag, word_tokenize
from nltk.corpus import stopwords
from nltk.tokenize import sent_tokenize
import json
import os
from collections import Counter
import heapq
import pyttsx3

# Download required NLTK data
nltk.download('vader_lexicon')
nltk.download('punkt')
nltk.download('averaged_perceptron_tagger')
nltk.download('maxent_ne_chunker')
nltk.download('words')
nltk.download('stopwords')

class AuthManager:
    def __init__(self):
        # Explicitly set db.json in the current working directory
        self.users_file = os.path.join(os.getcwd(), "db.json")
        if not os.path.exists(self.users_file):
            with open(self.users_file, 'w') as f:
                json.dump({}, f)

    def load_users(self):
        with open(self.users_file, 'r') as f:
            return json.load(f)

    def save_users(self, users):
        with open(self.users_file, 'w') as f:
            json.dump(users, f, indent=4)

class NLPProcessor:
    def __init__(self):
        self.sid = SentimentIntensityAnalyzer()
        self.stop_words = set(stopwords.words('english'))
        self.tts_engine = pyttsx3.init()

    def analyze_sentiment(self, text):
        scores = self.sid.polarity_scores(text)
        if scores['compound'] >= 0.05:
            return "Positive", scores['compound']
        elif scores['compound'] <= -0.05:
            return "Negative", scores['compound']
        else:
            return "Neutral", scores['compound']

    def extract_entities(self, text):
        chunked = ne_chunk(pos_tag(word_tokenize(text)))
        entities = []
        for subtree in chunked:
            if hasattr(subtree, 'label'):
                entity = " ".join(c[0] for c in subtree)
                entities.append((entity, subtree.label()))
        return entities

    def detect_intent(self, text):
        text = text.lower()
        words = [w for w in word_tokenize(text) if w not in self.stop_words]
        if any(word in ['buy', 'purchase', 'order'] for word in words):
            return "Purchase Intent"
        elif any(word in ['question', 'help', 'how', 'what'] for word in words):
            return "Question Intent"
        elif any(word in ['thanks', 'thank', 'appreciate'] for word in words):
            return "Gratitude Intent"
        else:
            return "General Intent"

    def analyze_sentiment(self, text):
        scores = self.sid.polarity_scores(text)
        if scores['compound'] >= 0.05:
            return "Positive", scores['compound']
        elif scores['compound'] <= -0.05:
            return "Negative", scores['compound']
        else:
            return "Neutral", scores['compound']

    def extract_entities(self, text):
        chunked = ne_chunk(pos_tag(word_tokenize(text)))
        entities = []
        for subtree in chunked:
            if hasattr(subtree, 'label'):
                entity = " ".join(c[0] for c in subtree)
                entities.append((entity, subtree.label()))
        return entities

    def detect_intent(self, text):
        text = text.lower()
        words = [w for w in word_tokenize(text) if w not in self.stop_words]
        if any(word in ['buy', 'purchase', 'order'] for word in words):
            return "Purchase Intent"
        elif any(word in ['question', 'help', 'how', 'what'] for word in words):
            return "Question Intent"
        elif any(word in ['thanks', 'thank', 'appreciate'] for word in words):
            return "Gratitude Intent"
        else:
            return "General Intent"

    def extract_keywords(self, text, num_keywords=5):
        words = [w.lower() for w in word_tokenize(text) if w.lower() not in self.stop_words and w.isalnum()]
        word_freq = Counter(words)
        return word_freq.most_common(num_keywords)

    def summarize_text(self, text, num_sentences=2):
        sentences = sent_tokenize(text)
        if len(sentences) <= num_sentences:
            return text
        
        word_freq = Counter([w.lower() for w in word_tokenize(text) 
                           if w.lower() not in self.stop_words and w.isalnum()])
        
        sentence_scores = {}
        for sent in sentences:
            for word, freq in word_freq.most_common(10):
                if word in sent.lower():
                    sentence_scores[sent] = sentence_scores.get(sent, 0) + freq
        
        summary_sentences = heapq.nlargest(num_sentences, sentence_scores, key=sentence_scores.get)
        return " ".join(summary_sentences)

    def text_to_speech(self, text):
        self.tts_engine.say(text)
        self.tts_engine.runAndWait()

class HistoryManager:
    def __init__(self):
        self.history = []

    def add_analysis(self, text, results):
        self.history.append({
            "text": text,
            "results": results
        })

    def get_history(self):
        return self.history

class NLPApp:
    def __init__(self):
        self.root = tk.Tk()
        self.root.title("Advanced NLP Tool")
        self.root.geometry("900x700")
        self.root.configure(bg="#000000")
        
        self.auth = AuthManager()
        self.nlp = NLPProcessor()
        self.history = HistoryManager()
        self.blinking = False
        
        # Configure ttk style for black background and Verdana font
        style = ttk.Style()
        style.theme_use('default')
        style.configure("Dark.TFrame", background="#000000", relief="flat")
        style.configure("TLabel", background="#000000", foreground="#FFFFFF", font=("Verdana", 12))
        style.configure("TButton", background="#444444", foreground="#FFFFFF", font=("Verdana", 12), 
                       borderwidth=0, padding=6)
        style.map("TButton", background=[('active', '#666666')])
        style.configure("TEntry", fieldbackground="#222222", foreground="#FFFFFF", font=("Verdana", 12))
        
        self.login_gui()
        self.root.mainloop()

    def clear_window(self):
        for widget in self.root.winfo_children():
            widget.destroy()

    def login_gui(self):
        self.clear_window()
        
        frame = ttk.Frame(self.root, padding="20", style="Dark.TFrame")
        frame.pack(fill="both", expand=True)
        
        ttk.Label(frame, text="Advanced NLP Tool", font=("Verdana", 24, "bold")).pack(pady=(0, 20))
        
        ttk.Label(frame, text="Email").pack()
        self.email_input = ttk.Entry(frame, width=50)
        self.email_input.pack(pady=5)
        
        ttk.Label(frame, text="Password").pack()
        self.password_input = ttk.Entry(frame, width=50, show="*")
        self.password_input.pack(pady=5)
        
        self.login_status = ttk.Label(frame, text="", foreground="red")
        self.login_status.pack(pady=5)
        
        ttk.Button(frame, text="Login", command=self.login).pack(pady=10)
        ttk.Label(frame, text="Not a member?").pack()
        ttk.Button(frame, text="Register", command=self.register_gui).pack(pady=10)

    def register_gui(self):
        self.clear_window()
        
        frame = ttk.Frame(self.root, padding="20", style="Dark.TFrame")
        frame.pack(fill="both", expand=True)
        
        ttk.Label(frame, text="Register", font=("Verdana", 24, "bold")).pack(pady=(0, 20))
        
        ttk.Label(frame, text="Name").pack()
        self.reg_name = ttk.Entry(frame, width=50)
        self.reg_name.pack(pady=5)
        
        ttk.Label(frame, text="Email").pack()
        self.reg_email = ttk.Entry(frame, width=50)
        self.reg_email.pack(pady=5)
        
        ttk.Label(frame, text="Password").pack()
        self.reg_password = ttk.Entry(frame, width=50, show="*")
        self.reg_password.pack(pady=5)
        
        ttk.Label(frame, text="Confirm Password").pack()
        self.reg_confirm = ttk.Entry(frame, width=50, show="*")
        self.reg_confirm.pack(pady=5)
        
        self.reg_status = ttk.Label(frame, text="", foreground="red")
        self.reg_status.pack(pady=5)
        
        ttk.Button(frame, text="Register", command=self.register).pack(pady=10)
        ttk.Button(frame, text="Back to Login", command=self.login_gui).pack(pady=10)

    def login(self):
        email = self.email_input.get()
        password = self.password_input.get()
        users = self.auth.load_users()
        
        if email in users and users[email]["password"] == password:
            self.main_gui(users[email]["name"])
        else:
            self.login_status.config(text="Invalid email or password")

    def register(self):
        name = self.reg_name.get()
        email = self.reg_email.get()
        password = self.reg_password.get()
        confirm = self.reg_confirm.get()
        
        if not all([name, email, password, confirm]):
            self.reg_status.config(text="All fields are required")
            return
        
        if password != confirm:
            self.reg_status.config(text="Passwords do not match")
            return
        
        users = self.auth.load_users()
        if email in users:
            self.reg_status.config(text="Email already registered")
            return
            
        users[email] = {
            "name": name,
            "password": password
        }
        self.auth.save_users(users)
        self.reg_status.config(text="Registration successful!", foreground="green")
        self.root.after(2000, self.login_gui)

    def show_history(self):
        history_window = tk.Toplevel(self.root)
        history_window.title("Analysis History")
        history_window.geometry("600x400")
        history_window.configure(bg="#000000")
        
        text_widget = tk.Text(history_window, height=20, width=70, bg="#222222", fg="#FFFFFF", 
                            font=("Verdana", 12))
        text_widget.pack(pady=20)
        
        for entry in self.history.get_history():
            text_widget.insert(tk.END, f"Text: {entry['text'][:50]}...\n")
            for key, value in entry['results'].items():
                text_widget.insert(tk.END, f"{key}: {value}\n")
            text_widget.insert(tk.END, "-"*50 + "\n")

    def export_results(self):
        results = self.history.get_history()[-1] if self.history.get_history() else {}
        if not results:
            messagebox.showwarning("Warning", "No analysis results to export")
            return
        
        file_path = filedialog.asksaveasfilename(defaultextension=".txt",
                                               filetypes=[("Text files", "*.txt"), ("All files", "*.*")])
        if file_path:
            with open(file_path, 'w') as f:
                f.write(f"Analyzed Text: {results['text']}\n\n")
                for key, value in results['results'].items():
                    f.write(f"{key}: {value}\n")
            messagebox.showinfo("Success", "Results exported successfully")

    def generate_word_cloud(self):
        text = self.text_input.get("1.0", tk.END).strip()
        if not text:
            messagebox.showwarning("Warning", "Please enter text to generate word cloud")
            return
        keywords = self.nlp.extract_keywords(text, 10)
        messagebox.showinfo("Word Cloud", "Word cloud would be generated with these keywords:\n" + 
                          "\n".join([f"{k} ({c})" for k, c in keywords]))

    def text_to_speech(self):
        text = self.text_input.get("1.0", tk.END).strip()
        if text:
            self.nlp.text_to_speech(text)
        else:
            messagebox.showwarning("Warning", "Please enter text to convert to speech")

    def blink_dots(self):
        if not self.blinking:
            return
        
        current_text = self.text_input.get("1.0", tk.END).strip()
        if current_text.endswith("..."):
            new_text = current_text[:-3]
        elif current_text.endswith(".."):
            new_text = current_text[:-2] + "..."
        elif current_text.endswith("."):
            new_text = current_text[:-1] + ".."
        else:
            new_text = current_text + "."
        
        self.text_input.delete("1.0", tk.END)
        self.text_input.insert("1.0", new_text)
        self.root.after(500, self.blink_dots)

    def start_blinking(self):
        if not self.blinking:
            self.blinking = True
            self.blink_dots()

    def stop_blinking(self):
        self.blinking = False
        current_text = self.text_input.get("1.0", tk.END).strip()
        if current_text.endswith("...") or current_text.endswith("..") or current_text.endswith("."):
            clean_text = current_text.rstrip(".")
            self.text_input.delete("1.0", tk.END)
            self.text_input.insert("1.0", clean_text)

    def on_text_change(self, event):
        self.stop_blinking()
        self.start_blinking()

    def main_gui(self, user_name):
        self.clear_window()
        
        main_frame = ttk.Frame(self.root, padding="30", style="Dark.TFrame")
        main_frame.pack(fill="both", expand=True)
        
        # Header section
        header_frame = ttk.Frame(main_frame, style="Dark.TFrame")
        header_frame.pack(fill="x", pady=(0, 20))
        
        ttk.Label(header_frame, text=f"Welcome, {user_name}!", 
                 font=("Verdana", 24, "bold")).pack()
        ttk.Label(header_frame, text="Analyze text with cutting-edge NLP features", 
                 font=("Verdana", 14)).pack(pady=5)
        
        # Input section with styled border
        input_frame = ttk.Frame(main_frame, style="Dark.TFrame", borderwidth=2, relief="groove")
        input_frame.pack(fill="x", pady=20)
        
        ttk.Label(input_frame, text="Enter Your Text Below:", 
                 font=("Verdana", 16)).pack(pady=(10, 5))
        self.text_input = tk.Text(input_frame, height=5, width=70, bg="#222222", fg="#FFFFFF", 
                                font=("Verdana", 12), borderwidth=0,
                                insertbackground="#FFFFFF", insertwidth=2)
        self.text_input.pack(pady=10, padx=10)
        self.text_input.focus_set()
        
        # Bind events for blinking control
        self.text_input.bind("<KeyPress>", lambda e: self.stop_blinking())
        self.text_input.bind("<KeyRelease>", self.on_text_change)
        self.text_input.bind("<FocusIn>", lambda e: self.start_blinking())
        self.text_input.bind("<FocusOut>", lambda e: self.stop_blinking())
        
        self.start_blinking()
        
        ttk.Button(input_frame, text="Analyze Now", command=self.analyze_text, 
                  style="TButton").pack(pady=(0, 10))

        # Results section
        self.results_frame = ttk.Frame(main_frame, style="Dark.TFrame")
        self.results_frame.pack(fill="x", pady=20)
        
        self.results_labels = {}
        for analysis in ["Sentiment", "Entities", "Intent", "Keywords", "Summary"]:
            label = ttk.Label(self.results_frame, text=f"{analysis}: Not analyzed", 
                            justify="center", wraplength=800, font=("Verdana", 14))
            label.pack(pady=5)
            self.results_labels[analysis] = label
        
        # Buttons section with grid layout
        button_frame = ttk.Frame(main_frame, style="Dark.TFrame")
        button_frame.pack(pady=20)
        
        buttons = [
            ("Show History", self.show_history),
            ("Clear Text", lambda: self.text_input.delete("1.0", tk.END)),
            ("Text to Speech", self.text_to_speech),
            ("Export Results", self.export_results),
            ("Word Cloud", self.generate_word_cloud),
            ("Logout", self.login_gui)
        ]
        
        for i, (text, command) in enumerate(buttons):
            ttk.Button(button_frame, text=text, command=command).grid(row=0, column=i, padx=5, pady=5, sticky="ew")
        
        button_frame.grid_columnconfigure(tuple(range(len(buttons))), weight=1)

    def analyze_text(self):
        self.stop_blinking()
        text = self.text_input.get("1.0", tk.END).strip()
        if not text:
            messagebox.showwarning("Warning", "Please enter text to analyze")
            self.start_blinking()
            return
        
        sentiment, score = self.nlp.analyze_sentiment(text)
        self.results_labels["Sentiment"].config(text=f"Sentiment: {sentiment} (Score: {score:.3f})")
        
        entities = self.nlp.extract_entities(text)
        entities_text = "\n".join([f"{e} ({t})" for e, t in entities]) or "No entities found"
        self.results_labels["Entities"].config(text=f"Entities:\n{entities_text}")
        
        intent = self.nlp.detect_intent(text)
        self.results_labels["Intent"].config(text=f"Intent: {intent}")
        
        keywords = self.nlp.extract_keywords(text)
        keywords_text = ", ".join([f"{k} ({c})" for k, c in keywords])
        self.results_labels["Keywords"].config(text=f"Keywords: {keywords_text}")
        
        summary = self.nlp.summarize_text(text)
        self.results_labels["Summary"].config(text=f"Summary: {summary}")
        
        results = {
            "Sentiment": f"{sentiment} (Score: {score:.3f})",
            "Entities": entities_text,
            "Intent": intent,
            "Keywords": keywords_text,
            "Summary": summary
        }
        self.history.add_analysis(text, results)
        self.start_blinking()

if __name__ == "__main__":
    app = NLPApp()