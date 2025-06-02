# Fiction_exp
## content
[exiprement](#exiprement)  
[DataProcess](#DataProcess)

## exiprement
- one trial(72 trial)
![image](https://github.com/user-attachments/assets/1579ce99-fcbb-4a85-a4e2-c8c7785c4052)
```每個trial，讓受試者讀一篇故事，讀完後給予一個eye Gaze(直視 or 迴避)的刺激，然後詢問三個問題```  
``` 以某個人(18)為主角的故事，分成正向情緒以及負向情緒(2)，以及直視or迴避的刺激(2)，所以有18*2*2=72個trial```
``` Q2 : 覺得故事是正向還是負向 ```
``` Q3 : 覺得這個故事的情緒是哪種(四選一) ```
  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)

## DataProcess
- step 1 : organize event and behave data  
  把event的資料提取出來，主要需要Arousal(受試者認為情緒強度為多少)，story(neg. or pos.)，Character(故事角色)，根據盼琳給的table去append他那邊EEG的時間位置。
  [Detail -- event資料、行為資料](./WorkLog/DataProcDetail.md)
- step 2 : preprocessing eeg data  
  1 . 資料filter 1-30Hz
  
  2 . ASR抑制震幅太大的資料

  3 . ICA只保留brain跟other
  
  4 . 把在閱讀過程中的資料切出來
  
  5 . 根據閱讀時間的長短把outlier剔除  

  ![image](https://github.com/user-attachments/assets/c273ba72-b611-4e67-8f18-2c92655dbfa8)
  

    
 ![image](https://github.com/user-attachments/assets/c217c959-9796-498b-8ebb-6b4959437a46)


&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

