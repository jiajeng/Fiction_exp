# Fiction_exp
## content
[實驗流程](#實驗流程)  
[event資料](#Event資料)    
[行為資料](#行為資料)   
[eeg資料](#eeg資料)    

[preprocessing](#preprocessing)  
[1st level](#1stlevel)    
[2nd level](#2ndlevel)   

## 實驗流程
- one trial(72 trial)
![image](https://github.com/user-attachments/assets/1579ce99-fcbb-4a85-a4e2-c8c7785c4052)
```每個trial，讓受試者讀一篇故事，讀完後給予一個eye Gaze(直視 or 迴避)的刺激，然後詢問三個問題```  
``` 以某個人(18)為主角的故事，分成正向情緒以及負向情緒(2)，以及直視or迴避的刺激(2)，所以有18*2*2=72個trial```
``` Q2 : 覺得故事是正向還是負向 ```
``` Q3 : 覺得這個故事的情緒是哪種(四選一) ```
  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)

## Event資料
### DataStructure
- EEG Data : ```E:\Fiction_experiment\Data``` (R811 PC)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ```/LabData/Panlin Fiction EEG``` (NAS 120.126.102.101)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; every subject has two .eeg file. Merge them should has 72 trials. if not then it must redo some trials.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;don't know which trial is redo and which not -- 2024/11/21

- triallist : ```E:\Fiction_experiment\Triallist``` (R811 PC)   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;```/LabData/Panlin Fiction EEG/Triallist ``` (NAS 120.126.102.101)  
  
| p01 | Character |	Story |	story. no. | Condition | Arousal | Q2.ACC | Q3.ACC | Eye.OnsetDelay | number |  latency | type | Condition2 | Condition3 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `subjectID` | `CharacterName` |	`Neg. Pos.` |	`50:neg. 60:pos.` | `bit1:3(neg.)         4(pos.) bit2: 3,4(congruent) 1(incongruent)` | `story_tone Arousal(1-9)` | `Q2.Accuracy subject_think_positive_or_negetive` | `Q3.Accuracy 1/4_emtion_select` | `??` | `index in eeg event file` | `eeg latency` | `eeg event type` | `story condition(emotion)` | `subject think condition(emotion)` |
| 1 | 克郎 | N | 50 | 33 | 6 | 1 | 1 | 0 | 7 | 58365 | S31 | 33 | 33 | 
| 2 | 克郎 | P | 60 | 44 | 9 | 1 | 1 | 0 | 15 | 94998 | S31 | 44 | 44 | 
| 3 | 克郎 | P | 60 | 41 | 4 | 1 | 1 | 0 | 23 | 121347 | S31 | 41 | 41 | 
|..|..|..|..|..|..|..|..|..|..|..|..|..|
| 7 | 雄治 | N | 50 | 31 | 6 | 1 | 0 | 0 | 55 | 285595 | S31 | 319 | 319 |
|..|..|..|..|..|..|..|..|..|..|..|..|..|..|

### EventType
![image](https://github.com/user-attachments/assets/0f1bf32d-ef89-422c-aa2b-2798024333e1)

### event資料處理
#### eDat file
- 把這裡的資料整理成上面的的模樣[structure](#DataStructure)，

| eDat Name | eventfile Name |
|--|--|
| Character | Character |
| PN | story |
| condition or con_re | condition |
| Que1_Slider1_Value | arousal |
| Que2_ACC | Q2.ACC |
| Que3_ACC | Q3.ACC |
| Eye_OnsetDelay | Eye_OnsetDelay |

> [!Note]
> condition不準，好像有些不同的命名方式，有的跑出來的值跟condition2不一樣，所以以condition2為準。

#### event file 
eDat file --> `整理好的eDat file` and event file --> `eeg trial event flie`    
- eDat加上盼琳給的資料(整理出來eeg trial的event file)。
- if eeg event file長度小於eDat資料，找到eeg event file Condition2不等於99(該trial刪掉)的，塞進去。
- if eeg event file長度大於eDat資料，刪掉eeg event file Condition2等於99的，然後接起來。

- eDatfile and event file 合併存成一個excel file
![image](https://github.com/user-attachments/assets/84c77d76-3349-46ac-8fa1-9857846b1ad5)    

#### resort event file
- 把所有的event file根據自定義的順序排序
![image](https://github.com/user-attachments/assets/8b14059a-6114-4b18-bf98-d2b76757937b)

- 所以每個epoch完的trial_1就是克朗31，trial_2就是克朗33，...
   
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)

## 行為資料
### reading Time
- 在對eeg做epoch的時候，將每個trial的時長都抓出來，加在resort event file後面，整理成下面的表格。
![image](https://github.com/user-attachments/assets/183f75f8-1ef3-44a0-8163-7c03f5486f76)
### behave score 
- 原有的表格(50subjects_behavior score.xlsx)(下表)，分給每個受試者的資料夾內(info.txt)
![image](https://github.com/user-attachments/assets/441b38f9-1a91-4d7a-91a4-602bc51f2734)  
![image](https://github.com/user-attachments/assets/ac2e9bbf-d8f8-4420-8d7f-b268813ed29c)  
![image](https://github.com/user-attachments/assets/eb33c512-2fb7-4b4f-a807-3bf12d92bd28)  




     
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)

## eeg資料
### convert file (vhdr to set)
input(raw) file `./"subid"/raweeg/ ` `E:\Fiction_experiment\Data\p01\raweeg\ --> Nas : /LabData/jeng/Fiction_experiment`  
output to `./"subid"/eegSet/Raw/ ` `E:\Fiction_experiment\Data\p01\eegSet\Raw\ --> Nas : /LabData/jeng/Fiction_experiment`  

### merge file
input file `./"subid"/eegSet/Raw/ ` `E:\Fiction_experiment\Data\p01\eegSet\Raw\ --> Nas : /LabData/jeng/Fiction_experiment`  
output to `./"subid"/eegSet/RawMerg/` `E:\Fiction_experiment\Data\p01\eegSet\RawMerg\ --> Nas : /LabData/jeng/Fiction_experiment`    
  
### preprocessing 
- filter(1-30 Hz)  
input file ` ./"subid"/eegSet/Raw`    
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; `E:\Fiction_experiment\Data\p01\eegSet\RawMerg\ --> Nas : /LabData/jeng/Fiction_experiment`  
output to ` ./"subid"/eegSet/prep/f*.set`    
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; `E:\Fiction_experiment\Data\p01\eegSet\prep\f*.set --> Nas : /LabData/jeng/Fiction_experiment`
- ASR(criterion is 20)   
input file `./"subid"/eegSet/prep/f*.set`    
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; `E:\Fiction_experiment\Data\p01\eegSet\prep\f*.set --> Nas : /LabData/jeng/Fiction_experiment`  
output file `./"subid"/eegSet/prep/af*.set`    
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; `E:\Fiction_experiment\Data\p01\eegSet\prep\af*.set --> Nas : /LabData/jeng/Fiction_experiment`  
- ICA(retains component brain and other)  
input file `./"subid"/eegSet/prep/af*.set`  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; `E:\Fiction_experiment\Data\p01\eegSet\prep\af*.set --> Nas : /LabData/jeng/Fiction_experiment`  
output file `./"subid"/eegSet/prep/iaf*.set`    
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; `E:\Fiction_experiment\Data\p01\eegSet\prep\iaf*.set --> Nas : /LabData/jeng/Fiction_experiment`  --> not remove component    
output file `./"subid"/eegSet/prep/riaf*.set`    
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; `E:\Fiction_experiment\Data\p01\eegSet\prep\riaf*.set --> Nas : /LabData/jeng/Fiction_experiment`  --> remove component
- epoch(get event type 21 to 22, store every trial in individual file)  
input file `./"subid"/eegSet/prep/riaf*.set`    
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; `E:\Fiction_experiment\Data\p01\eegSet\prep\riaf*.set --> Nas : /LabData/jeng/Fiction_experiment`  
output file `./"subid"/eegSet/process/trials_21to22`  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; `E:\Fiction_experiment\Data\p01\eegSet\process\trials_21to22\tn*.set --> Nas : /LabData/jeng/Fiction_experiment`  --> should have excactly 72 trials

### get reading story time  
- `get trials data` -->  `get time latency in type 21 to 22 ` --> `store all trial time in one column` --> `save this variable`   
input file`./"subid"/eegSet/process/trials_21to22`  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; `E:\Fiction_experiment\Data\p01\eegSet\process\trials_21to22\tn*.set --> Nas : /LabData/jeng/Fiction_experiment`  
output file `./"subid"/eegSet/process/RdTime.mat (variable Name = oTab, size = 72x1 cell)`  

### transform to frequency data
input file`./"subid"/eegSet/process/trials_21to22`  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; `E:\Fiction_experiment\Data\p01\eegSet\process\trials_21to22\tn*.set --> Nas : /LabData/jeng/Fiction_experiment`   
- ` get 5 second data before finish reading story(type 22)` --> for now 20241206
- ` using wavelet transform to get frequency complex data(matrix size : freq x time) `
- ` split complex data to different frequency band(delta,theta , alpha, beta), still in complex data`
- ` compute average band power `
- ` store data in .mat file `
- optional plot
- ` plot band power in every electrode for every trials, save in output file subfolder "heatmap"`  
 ![image](https://github.com/user-attachments/assets/062c6877-3b56-4171-80ea-fab04d40fd2e)
output file `./"subid"/eegSet/process/trials_21to22_TF`
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; `E:\Fiction_experiment\Data\p01\eegSet\process\trials_21to22_TF\tn*.mat --> Nas : /LabData/jeng/Fiction_experiment`

### <a name="1stlevle"></a> statistic 1st level 

#### model 1
### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $\ Y+ = B_0 + B_1delta + B_2theta + B_3alpha + B_4beta)\$  
### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $\ Y- = B_0 + B_1delta + B_2theta + B_3alpha + B_4beta)\$  
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $Y\$: arousal
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $B_0\$ : intercept  
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $B_1 - B_4\$ : effect of frequency band

#### model 2
### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $\ Y = B_0 + B_1delta + B_2theta + B_3alpha + B_4beta + B_5contrast + B_6(delta * contrast) + B_7(theta * contrast) + B_8(alpha * contrast) + B_9(beta * contrast)\$  
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $Y\$: arousal
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $B_0\$ : intercept  
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $B_1 - B_4\$ : effect of frequency band in story negative  
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $B_5\$ : General difference between story neg. and pos.(intercept)  
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $B_6 - B_9\$ : difference in the effect of frequnecy band between story neg. and pos.  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

### <a name="2ndlevel"></a> statistic 2nd level 
#### model 1
### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $\ Y+ = B_0 + B_1Age + B_2Sex\$
### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $\ Y+ = B_0 + B_1Age + B_2Sex + B_3IRI_Fantacy + B_4(Age * IRI_Fantacy)\$ 
### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $\ Y+ = B_0 + B_1Age + B_2Sex + B_3IRI_Perspective + B_4(Age * IRI_Perspective)\$ 
### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $\ Y+ = B_0 + B_1Age + B_2Sex + B_3IRI_Empathic + B_4(Age * IRI_Empathic)\$ 
### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $\ Y+ = B_0 + B_1Age + B_2Sex + B_3IRI_Distress + B_4(Age * IRI_Distress)\$ 

### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $\ Y- = B_0 + B_1Age + B_2Sex\$
### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $\ Y- = B_0 + B_1Age + B_2Sex + B_3IRI_Fantacy + B_4(Age * IRI_Fantacy)\$ 
### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $\ Y- = B_0 + B_1Age + B_2Sex + B_3IRI_Perspective + B_4(Age * IRI_Perspective)\$ 
### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $\ Y- = B_0 + B_1Age + B_2Sex + B_3IRI_Empathic + B_4(Age * IRI_Empathic)\$ 
### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $\ Y- = B_0 + B_1Age + B_2Sex + B_3IRI_Distress + B_4(Age * IRI_Distress)\$ 

#### model 2
### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $\ Y = B_0 + B_1Age + B_2Sex + B_3IRI_Fantacy + B_4IRI_Perspective + B_5IRI_Empathic + B_6IRI_Distress\$
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $Y\$ : delta/theta/alpha/beta difference effect $B_6 ~ B_9$
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $B_0\$ : intercept  
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $B_1 - B_6\$ : effect of behave   

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)



