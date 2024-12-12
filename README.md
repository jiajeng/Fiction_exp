# Fiction_exp
### 實驗流程
- one trial(72 trial)
![image](https://github.com/user-attachments/assets/1579ce99-fcbb-4a85-a4e2-c8c7785c4052)
```每個trial，讓受試者讀一篇故事，讀完後給予一個eye Gaze(直視 or 迴避)的刺激，然後詢問三個問題```  
``` 以某個人(18)為主角的故事，分成正向情緒以及負向情緒(2)，以及直視or迴避的刺激(2)，所以有18*2*2=72個trial```
``` Q2 : 覺得故事是正向還是負向 ```
``` Q3 : 覺得這個故事的情緒是哪種(四選一) ```

### Data structure
- EEG Data : ```E:\Fiction_experiment\Data``` (R811 PC)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ```/LabData/Panlin Fiction EEG``` (NAS 120.126.102.101)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; every subject has two .eeg file. Merge them should has 72 trials. if not then it must redo some trials.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;don't know which trial is redo and which not -- 2024/11/21

- triallist : ```E:\Fiction_experiment\Triallist``` (R811 PC)   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;```/LabData/Panlin Fiction EEG/Triallist ``` (NAS 120.126.102.101)  

| p01 | Character |	Story |	story. no. | Condition | Arousal | Q2.ACC | Q3.ACC | Condition2 | Condition3 | Eye.OnsetDelay |  
|---|---|---|---|---|---|---|---|---|---|---|
| `subjectID` | `CharacterName` |	`Neg. Pos.` |	`50:neg. 60:pos.` | `bit1:3(neg.)         4(pos.) bit2: 3,4(congruent) 1(incongruent)` | `story_tone Arousal(1-9)` | `Q2.Accuracy subject_think_positive_or_negetive` | `Q3.Accuracy 1/4_emtion_select` | `story condition(emotion)` | `subject think condition(emotion)`  | `??` | 
| 1 | 克郎 | N | 50 | 33 | 6 | 1 | 1 | 33 | 33 | 0|
| 2 | 克郎 | P | 60 | 44 | 9 | 1 | 1 | 44 | 44 | 0|
| 3 | 克郎 | P | 60 | 41 | 4 | 1 | 1 | 41 | 41 | 0|
|..|..|..|..|..|..|..|..|..|..|
| 7 | 雄治 | N | 50 | 31 | 6 | 1 | 0 | 319 | 319 | 0|
|..|..|..|..|..|..|..|..|..|..|

### event type
![image](https://github.com/user-attachments/assets/0f1bf32d-ef89-422c-aa2b-2798024333e1)

### 資料處理
#### convert file (vhdr to set)
input(raw) file `./"subid"/raweeg/ ` `E:\Fiction_experiment\Data\p01\raweeg\ --> in 811 PC`  
output to `./"subid"/eegSet/Raw/ ` `E:\Fiction_experiment\Data\p01\eegSet\Raw\ --> in 811 PC`  
#### preprocessing 
- filter(1-30 Hz)  
input file ` ./"subid"/eegSet/Raw`    
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; `E:\Fiction_experiment\Data\p01\eegSet\Raw\ --> in 811 PC`  
output to ` ./"subid"/eegSet/prep/f*.set`    
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; `E:\Fiction_experiment\Data\p01\eegSet\prep\f*.set --> in 811 PC`
- ASR(criterion is 20)   
input file `./"subid"/eegSet/prep/f*.set`    
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; `E:\Fiction_experiment\Data\p01\eegSet\prep\f*.set --> in 811 PC`  
output file `./"subid"/eegSet/prep/af*.set`    
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; `E:\Fiction_experiment\Data\p01\eegSet\prep\af*.set --> in 811 PC`  
- ICA(retains component brain and other)  
input file `./"subid"/eegSet/prep/af*.set`  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; `E:\Fiction_experiment\Data\p01\eegSet\prep\af*.set --> in 811 PC`  
output file `./"subid"/eegSet/prep/iaf*.set`    
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; `E:\Fiction_experiment\Data\p01\eegSet\prep\iaf*.set --> in 811 PC`  --> not remove component    
output file `./"subid"/eegSet/prep/riaf*.set`    
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; `E:\Fiction_experiment\Data\p01\eegSet\prep\riaf*.set --> in 811 PC`  --> remove component
- epoch(get event type 21 to 22, store every trial in individual file)  
input file `./"subid"/eegSet/prep/riaf*.set`    
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; `E:\Fiction_experiment\Data\p01\eegSet\prep\riaf*.set --> in 811 PC`  
output file `./"subid"/eegSet/process/trials_21to22`  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; `E:\Fiction_experiment\Data\p01\eegSet\process\trials_21to22\tn*.set --> in 811 PC`  --> should have excactly 72 trials   
#### get reading story time  
- `get trials data` -->  `get time latency in type 21 to 22 ` --> `store all trial time in one column` --> `save this variable`   
input file`./"subid"/eegSet/process/trials_21to22`  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; `E:\Fiction_experiment\Data\p01\eegSet\process\trials_21to22\tn*.set --> in 811 PC`  
output file `./"subid"/eegSet/process/RdTime.mat (variable Name = oTab, size = 72x1 cell)`
#### transform to frequency data
input file`./"subid"/eegSet/process/trials_21to22`  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; `E:\Fiction_experiment\Data\p01\eegSet\process\trials_21to22\tn*.set --> in 811 PC`   
- ` get 5 second data before finish reading story(type 22)` --> for now 20241206
- ` using wavelet transform to get frequency complex data(matrix size : freq x time) `
- ` split complex data to different frequency band(delta,theta , alpha, beta), still in complex data`
- ` compute average band power `
- ` store data in .mat file `
- optional plot
- ` plot band power in every electrode for every trials, save in output file subfolder "heatmap"`  
 ![image](https://github.com/user-attachments/assets/062c6877-3b56-4171-80ea-fab04d40fd2e)
output file `./"subid"/eegSet/process/trials_21to22_TF`
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; `E:\Fiction_experiment\Data\p01\eegSet\process\trials_21to22_TF\tn*.mat --> in 811 PC`
#### statistic 1st level 

  

