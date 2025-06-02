`result folder : E:\Fiction_experiment\Data\Result\2ndLevel`

- step 1 : one sample ttest for pos./neg. story freqeuncy band  
  用GLM去算，Y放頻段power，X只放intercept，看intercept(mean)有沒有顯著(有沒有>0)。
    
- step 2 : first and second level for eeg data
    
  - first level   
    分成兩種模型
       
    1 . 正負向故事分開分析，看正向故事跟負向故事中，受試者認為的情感強度(Y)跟EEG不同的頻段(X)的beta值
      
    2 . 正負向故事放一起分析，看正向跟負向故事，受試者認為的情感強度(Y)跟EEG不同頻段的(X)的beta值，以及正負向的差異
    
  - second level

    把first level的Beta值(每個頻段，總共有四個頻段，分別跑四個模型)拿去跟行為資料去做GLM  
    兩種模型放的beta值
      
    1 . 正負向故事單獨的情感強度Arousal跟delta(...)頻段的beta值，跟行為資料有沒有相關性(beta)存在
      
    2 . 正負向故事的情感強度Arousal跟delta(...)頻段的beta值差異，跟行為資料有沒有相關性(beta)存在

![image](https://github.com/user-attachments/assets/c217c959-9796-498b-8ebb-6b4959437a46)
