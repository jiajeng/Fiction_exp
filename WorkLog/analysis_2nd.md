`Result : E:\Fiction_experiment\Data\Result\analysis_2nd`
- step 1 : transfer to frequency
  `welch method --> window = fs, noverlap = fs/2, nfft = fs`  
  
- time  
  - 檔名上標註`xxx_1, xxx_2, xxx_3`, 把讀故事的整段拆分成三段，分別是第一段、第二段、第三段去分析。  
  - 檔名上標註`xxx_all`，把整段時間都拿去分析。  
  
- power feature  
  - abs : 10*log10(BandPower)  
  - rel : 10*log10(BandPower(1-4Hz,4-8Hz,8-12Hz,12-30Hz)/total Power(1-30Hz))    
  - ersp : 10*log10(Reading BandPower(1-4Hz)/Baseline BandPower(1-4Hz)) `Baseline : -1s start Reading`  
 
- step 2 : 1st level
  - behave(within subject)  
  Arousal = 1 + BandPower + condition(Pos. or neg. story) + BandPower*condition  
  從這個模型就可以知道，pos. story跟Arousal的相關、neg. story跟Arousal的相關 以及 pos.跟Arousal的相關-neg.跟Arousal的相關  

  - one sample T(within subject)  
  BandPower = 1  
 
- step 3 : 2nd level  
  - behave(between subject) `3 model`
    1st Estimate(P, N, P-N) = 1 + IRI_Fantasy + IRI_Perspective + IRI_Distress + IRI_Empathic  
    
  - one sample T(between subject)  
    1st Estimate = 1  
    
![image](https://github.com/user-attachments/assets/8746a727-98d3-40f8-8282-0eb5c4430d0a)
