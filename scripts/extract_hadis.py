import requests
from bs4 import BeautifulSoup
import json
import time
import os

def extract_hadith(kitab, hadith_id):
    url = f"https://hadis.my/kitab/{kitab}/{hadith_id}"
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
    }
    
    try:
        response = requests.get(url, headers=headers, timeout=10)
        if response.status_code == 404:
            return None
        response.raise_for_status()
        
        # Explicitly decode binary content as UTF-8
        try:
            html_content = response.content.decode('utf-8')
        except UnicodeDecodeError:
            # Fallback for unexpected cases
            html_content = response.text
            
        soup = BeautifulSoup(html_content, 'html.parser')
        article = soup.find('article')
        
        if not article:
            return None
            
        # Extract Arabic
        arabic_div = article.find('div', class_='mb-6')
        arabic_text = ""
        if arabic_div:
            arabic_text = arabic_div.get_text(strip=True)
            
        # Extract Malay
        malay_div = article.find('div', class_='border-amber-100')
        malay_text = ""
        if malay_div:
            # The text is usually after the flag/language span
            p_tag = malay_div.find('p')
            if p_tag:
                malay_text = p_tag.get_text(strip=True)
        
        return {
            "id": hadith_id,
            "arabic": arabic_text,
            "terjemahan_ms": malay_text
        }
    except Exception as e:
        print(f"Error fetching {kitab} {hadith_id}: {e}")
        return None

def main():
    # Final Configuration for Sahih Bukhari and Sahih Muslim
    # Based on hadis.my index
    kitabs = {
        "shahih-bukhari": {"start": 1, "end": 7008},
        "shahih-muslim": {"start": 1, "end": 5362}
    }
    
    output_dir = "data"
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
        
    print("\nStarting full Hadith extraction process...")
    print("This will take several hours. You can stop and resume anytime.\n")
    
    for kitab, config in kitabs.items():
        start = config["start"]
        end = config["end"]
        filename = f"{output_dir}/{kitab}.json"
        
        # Load existing progress if any
        results = []
        if os.path.exists(filename):
            try:
                with open(filename, "r", encoding="utf-8") as f:
                    results = json.load(f)
            except:
                pass
        
        print(f"Extracting {kitab} from {start} to {end}...")
        
        for i in range(start, end + 1):
            # Skip if already exists in results (simple check)
            if any(h["id"] == i for h in results):
                continue
                
            print(f"  Fetching {i}/{end}...")
            data = extract_hadith(kitab, i)
            if data:
                results.append(data)
                # Incremental save
                with open(filename, "w", encoding="utf-8") as f:
                    json.dump(results, f, ensure_ascii=False, indent=2)
            
            time.sleep(1) # Be nice to the server
            
    print("Batch processing complete!")

if __name__ == "__main__":
    main()
