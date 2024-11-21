# Fiction_exp
### 實驗流程
- one trial(72 trial)
![image](https://github.com/user-attachments/assets/1579ce99-fcbb-4a85-a4e2-c8c7785c4052)
```每個trial，讓受試者讀一篇故事，讀完後給予一個eye Gaze(直視 or 迴避)的刺激，然後詢問三個問題```  
``` 以某個人(18)為主角的故事，分成正向情緒以及負向情緒(2)，以及直視or迴避的刺激(2)，所以有18*2*2=72個trial```

### Data structure
- EEG Data : ```E:\Fiction_experiment\Data``` (R811 PC)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ```/LabData/Panlin Fiction EEG``` (NAS 120.126.102.101)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; every subject has two .eeg file. Merge them should has 72 trials. if not then it must redo some trials.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;don't know which trial is redo and which not -- 2024/11/21

- triallist : ```E:\Fiction_experiment\Triallist``` (R811 PC)   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;```/LabData/Panlin Fiction EEG/Triallist ``` (NAS 120.126.102.101)  

| p01 | Character |	Story |	story. no. | Condition | Arousal | Q2.ACC | Q3.ACC | Condition2 | Condition3 | Eye.OnsetDelay |  
|---|---|---|---|---|---|---|---|---|---|---|
| `subjectID` | `CharacterName` |	`Neg. Pos.` |	`50:neg. 60:pos.` | `bit1:3(neg.)         4(pos.) bit2: 3,4(eyeDirect) 1(eyeAverted)` | `story_tone neg.~pos.(1-10)` | `Q2.Accuracy` | `Q3.Accuracy` | `Q3.Acc incor. add bit3 9` | `Q3.Acc incor. add bit3 9`  | `??` | 
| 1 | 克郎 | N | 50 | 33 | 6 | 1 | 1 | 33 | 33 | 0|
| 2 | 克郎 | P | 60 | 44 | 9 | 1 | 1 | 44 | 44 | 0|
| 3 | 克郎 | P | 60 | 41 | 4 | 1 | 1 | 41 | 41 | 0|
|..|..|..|..|..|..|..|..|..|..|
| 7 | 雄治 | N | 50 | 31 | 6 | 1 | 0 | 319 | 319 | 0|
|..|..|..|..|..|..|..|..|..|..|



