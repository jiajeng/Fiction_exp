## content
[2024/12/02 Before](#241202_1) --> start with convert file type and preprocessing to epoch Data   
[2024/12/02](#241202_2) --> get reading timing   
[2024/12/05](#241205) --> using wavelet transform to get freqeuncy band     
[2024/12/06](#241206) --> statistical    
[2024/12/10](#241210) --> statistical two sample cluster fdr     
[2024/12/11](#241211) --> statistical GLM  
[2024/12/12](#241212) --> arrange event data using raw(?close) event file    
[2024/12/17](#241217) --> rearrage run process merge all file first --> aim to get trial  
[2024/12/25](#241225) --> check event table then run all subject preprocessing eeg data  
[2024/12/31](#241231) --> planning what to do  
[2025/1/9](#250109)  --> meet  
[2025/1/15](#250115) --> get outlier and transform to frequency   
[2025/2/3](#250203) --> meet  
[2025/2/6](#250206) --> stat GLM first level  
[2025/2/11](#250211) --> change design matrix  
[2025/2/12](#250212) --> plan to plot result and check statistic is right ?   
[2025/2/13](#250213) --> plot result(add stat_plotresult.m)   
[2025/2/14](#250214) --> Y=arousal model design   
[2025/02/17](#250217) --> plan what to do next   
[2025/02/18](#250218) -->   
[2025/02/25](#250225) --> result for two(neg. pos. story) model and GLM differnece     

[2025/05/13](#250513) --> fix get frequency band 


## ~241202<a id="241202_1"></a>
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   
`complete convert file and preprocessing`  
`output to subN/eegSet/rawset (for raw .set file)`  
`output to subN/eegSet/prep (for preprocessing file)`  

- ##### vhdr2set : convert .vhdr to .set file  
input : `vhdrpath`, "string", Get all .vhdr file in this path     
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`vhdrfile`, "struct", fields is folder and name  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`!! priority of input data, vhdrfile > vhdrpath `  
output : save .set file in `'vhdrfilepath'/../eegSet/Raw`  
- ##### prep_filt : preprocessing filter    
input : `cutoffF`, "real", cut off frequency to filter  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`filepath`, "string", Get all .set file under this path  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`file`, "struct", fields contains folder and name, like output of dir()  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`EEG`, "string", eeglab pattern  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`!! priority of input data, EEG > file > filepath`    
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`outpath`, "string", default outpath is `./eegSet/prep/`  
output : `./eegSet/prep/f*.set`  

- ##### prep_asr : preprocessing ASR
input : `filepath`, "string", Get all .set file under this path  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`file`, "struct", fields contains folder and name, like output of dir()  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`EEG`, "string", eeglab pattern  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`!! priority of input data, EEG > file > filepath`    
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`criterion`, "real", ASR criterion, default is 20    
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`outpath`, "string", default outpath is `./eegSet/prep/`  
output : `./eegSet/prep/a*.set`  
- ##### prep_ICA : preprocessing ICA
input : `filepath`, "string", Get all .set file under this path  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`file`, "struct", fields contains folder and name, like output of dir()  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`EEG`, "string", eeglab pattern  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`!! priority of input data, EEG > file > filepath`    
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`outpath`, "string", default outpath is `./eegSet/prep/`  
output : `./eegSet/prep/i*.set (run ica)` and `./eegSet/prep/ri*.set (remove component, retain brian and other)`  
- ##### epoch_Data : epoch type n to type m, save every trial in different .set file
input : `sttype`, "string", start event type  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`edtype`, "string", end event type   
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`filepath`, "string", Get all .set file under this path  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`file`, "struct", fields contains folder and name, like output of dir()  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`EEG`, "string", eeglab pattern    
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`!! priority of input data, EEG > file > filepath`   
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`outpath`, "string", default outpath is `./eegSet/process/`   
output : `./eegSet/process/trials_'sttype'to'edtype'/t*.set`  

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

## 241202<a id="241202_2"></a>
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   
- ##### allRdTime : get reading Time(unit s)
input : `filepath`, "string", Get all .set file under this path  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`file`, "struct", fields contains folder and name, like output of dir()  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`EEG`, "string", eeglab pattern  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`!! priority of input data, EEG > file > filepath`    
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`outpath`, "string", default outpath is `./eegSet/prep/`  
output : `./eegSet/process/RdTime.mat (RdTime, cell array)`  

> [!Note]
> 拿讀完的event前5s(就目前來說，33個受試者讀文章時間的1/4來算的(20s))來做分析，
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 


## 241205
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   
- ###### TF : wavelet transform to every trial
input : `filepath`, "string", Get all .set file under this path    
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`file`, "struct", fields contains folder and name, like output of dir()    
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`EEG`, "string", eeglab pattern    
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`!! priority of input data, EEG > file > filepath`      
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`freqBand`, "struct", fieldnames is fband name,   
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; `default is : freqBand.delta = [1,4], freqBand.theta = [4,8], freqBand.alpha = [8,12], freqBand.beta = [12,30]`  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`outpath`, "string", default outpath is `./eegSet/process/trial_ntom_TF`    
output : `./eegSet/process/trial_21to22_TF/tn*.mat (BdPow and TFd "struct" )`    
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; `plot heatmap data for every trial, row is electrode, column is time point, color data is average Band power value in this band`  
![image](https://github.com/user-attachments/assets/5603a230-49b9-4bab-aa79-5fbe8b8359fc)
`BdPow.chname, channel name`  
`BdPow."Band", 2-D array size = channel x time point`  
`TFd."chname".Tfdata, transform to frequency raw complex data, size = Hz x time`  
`TFd."chname".time, time point (unit s)`  
`TFd."chname".frq, freqency point (unit Hz)`  
`TFd."chname"."Band", split TFdata to different freq. Band`  


> [!Note]
> run statistic  

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 

## 241206
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

#### stat_TF
- `v` 1st level then 2nd level   
- `v` read all trial data
- `v` get t-values
- correction FDR

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 

## 241210
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

- cluster base correction(for one subject) `DONE`   
===== aim : positive story v.s negative story ====  
1.(real) get two condition  
2.(real) compute two sample t test   
3.(real) pool all condition together   
4.(perm) random get half to one coniditon and the other is another conidtion  
5.(perm) repeat 4. to 1000(set for user) times  
6.(real) set a threshold to t value (p = 0.05 using "tinv" function to get t thres)  
7.(real) set 6. threshold to 2. result  
8.(real) get cluster in 7.  
9.(real) sum each cluster t value in 8.   
10.(perm & real) using real cluster index to sum each perm t value  
11.(perm) find the max perm t value across all perm  
12.(perm) the perm distribution that contains max perm is the null hypothesis distribution  
13.(real & perm) using null hypothesis distribution and real data to get p value  
14.(real) !!get cluster-base correction result
  
- cluster base correction(for all subject) `NOT DONE`  
===== aim : positive story v.s negative story ====  
1.(real) `Get all subject t value map (31x5001xsubnum)`
2.(real) `compute one sample ttest to `

>[!Note]
> 或許用GLM來用好了，不用考慮要怎麼減
  

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 


## 241211
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   
- cluster base correction(1st level and 2nd level) `NOT DONE`  
========================= aim : GLM ====================  
1.(real) `Get all subject frequency band map (31x5001xsubnum)`
2.(real) `Y = BX --> Y : EEG frequency band, X :  `

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 
  
## 241212
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   
- 整理所有trial，讓所有的trial都對上同一個故事

>[!Note]
> 整理完eDat 正常72trial的資料，確認不正常的怎麼跑，例賽爾也要增加名子，長大的還是小時候的

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 
  
## 241217
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   
- 合併所有的EEG資料，`add prep_mergeFile.m`  
- 在prep_mergeFile裡，導入盼琳給的trial資料  
> [!Note]
> s16的event 好怪排序跟判林給我的資料不一樣
  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 

## 241225
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   
- eData 出來的結果順序不太一樣，  
- 這是照著eData的順序出來的結果  
- ![image](https://github.com/user-attachments/assets/e3fd9860-b823-4f88-89c9-625b4d96ea68)  
- 這是盼琳給我的結果  
- ![image](https://github.com/user-attachments/assets/ffbd60ce-6d62-40fc-9e69-254b357c1a9d)
- 這是盼琳給我的EEG event的結果
- ![image](https://github.com/user-attachments/assets/38e2cf76-f8f4-4008-a188-7b58d456559a)
  
- 在eData的資料裡面前面的受試者沒有con_re，只有condition，在後面的受試者就有con_re了，要改成讀這列資料，因為讀錯了所以資料才長的不一樣
- 
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 

## 241231
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   
- 有的人有con_re，有的沒有，目前是有con_re就拿con_re的資料，沒有就拿condition，但有的還是不一樣，就不管condition這欄了，直接複製盼琳給EEG event 的資料複製上去就行，目前也只看condition2 跟 condition3。  
- 目前做到把所有人的前處理資料都跑完了，到ICA，再跑epoch，有重新整理過event的資料，每個人的epoch01都是克朗_31，02是克朗_33，...  

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 


## 250109
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   
##### meet
- 對每個人的reading time去掉outlier，讀太快的部分就丟掉，或是讀太久的也丟掉。
- 留下來的trial根據自身的長度分成三段，轉成頻率
- 將每個trial根據受試者認為的是正向還是負向情緒分成不同組別去比較
- 如果有GLM的話，一樣放入age,sex,...,IRI score。


&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 

## 250115
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

- 把不是outleier的trial從epoch的資料夾裡複製出來另一個資料夾中 `RmOutlier.m`  
- 把挑出來的trial轉成頻率存成.mat檔 `FreqB.m`

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 


## 250116
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

- GLM
  - Y : 正向或是負向情緒，binary
  - X : frequency band
  - effect(2nd level) : subject, Sex, Age, IRI_Fantasy, IRI_Perspective, IRI_Empathic, IRI_Distress
- 

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 


## 250203
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

- GLM
  - Y : 正向或是負向情緒，binary * arousal
  - X : frequency band
  - effect(2nd level) : subject, Sex, Age, ~IRI_Fantasy, IRI_Perspective, IRI_Empathic, IRI_Distress~
- 
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 

## 250206
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

- stat_1stlevel.m
  - Parfile data struct :
  - `X : X value` : frequency band power
  - `X_name : x value names(meaning)`
  - `Y : y value` : objective score 
  - `Y_name : y value(meaning)`
  - `effect : 2nd level variable` : Age, 
  - `effect_name : effect value meaning`
- stat_2ndlevel.m
- Y : 1st Level Beta value
- X : Age, 


&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 


## 250211
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

- 1st level result like this
- +- arousal = theta + delta + alpha + beta
- ![image](https://github.com/user-attachments/assets/b70fc723-470a-4988-9de1-57dd40fa7def)
- non of any parameter is significant.
- scatter plot for theta and Y
- ![image](https://github.com/user-attachments/assets/369b3a84-a467-469f-bee7-c1e06e6dd3bd)

- maybe change model to --> arousal = delta + theta + alpha + beta + contast[[-1 or +1 that subject think is positive or negetive in this trial]]
- model
- ![image](https://github.com/user-attachments/assets/9d813ccc-6b3c-4c8b-994b-f9da619992fa)
- scatter plot for theta and Y
- ![image](https://github.com/user-attachments/assets/5f949d5a-8bc5-458a-a0cb-0e17a45bcff5)

- 2nd level model
- Y : beta value from 1st level (delta, theta, alpha, beta)
- X : Age, Sex, IRI_Fatancy, IRI_Perspective, IRI_Empathic, IRI_distress

- result :
- delta effect : IRI_Empathic
- theta effect : Age, IRI_Empathic
- alpha effect : Nan
- beta effect : Age, IRI_Empathic

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 


## 250212
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

- plot result
- frequency band
- 2 condition : positive and negative

##### GLM for regression ttest ANOVA
![image](https://github.com/user-attachments/assets/1484d74e-d5ec-43b4-b149-084dd18e1de8)
- regression :
  - X is continuous variables
- ttest : 
  - X is dummy variables(only contains 0s and 1s)
  - p-value is same as traditional way (model p-value ??)
  - betas `B0 is mean of 0s`,  `B1 is mean of 1s` for only one dummy code
- ANOVA
  - X is dummy variables(only contains 0s and 1s)
  - if has three groups then model has three beta value include interception
  - as figure above `B0 is mean of the reference group(0s)`, `B1 is mean of 0s - mean of 1s`, `B2 is mean of 0s - mean of 2s`
 


&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 

## 250213
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

- Y is arousal
- X is freqBand + contrast
  
or 
- Y is arousal * contrast
- X is freqBand
- Y越低Power越高，認為這個是negitave story的arousal越高則Power越高

##### add stat_plotresult
- input : Resfile `a absolute direction for 2nd level GLM.mat` or `contains *, ** direction `


- run two model arousal_pn and arousal
- plot all channel need to fix layout

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 


## 250214
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

### model 1
#### 1st level  
### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $\ Y = B_0 + B_1delta + B_2theta + B_3alpha + B_4beta\$
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $Y\$ : arousal x story pos. or neg.(subject think)
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $B_0\$ : intercept  
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $B_1 - B_4\$ : effect of frequency band  

#### 2nd level
### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $\ Y = B_0 + B_1Age + B_2Sex + B_3IRI_Fantacy + B_4IRI_Perspective + B_5IRI_Empathic + B_6IRI_Distress\$
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $Y\$ : delta/theta/alpha/beta effect
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $B_0\$ : intercept  
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $B_1 - B_6\$ : effect of behave   

#### result
![delta](https://github.com/user-attachments/assets/49e25e17-fd67-4b5d-b3b4-e734e9c8f0c3)    
![theta](https://github.com/user-attachments/assets/1c8cb0ca-b3eb-486b-8ab3-8868bcfb5130)
![alpha](https://github.com/user-attachments/assets/dcba7d6d-af99-4462-9e4a-b818fe11b9e0)  
![beta](https://github.com/user-attachments/assets/b1641416-3a73-4c99-96a4-1ce96892f550)  



### model 2
#### 1st level
### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $\ Y = B_0 + B_1delta + B_2theta + B_3alpha + B_4beta + B_5contrast + B_6(delta * contrast) + B_7(theta * contrast) + B_8(alpha * contrast) + B_9(beta * contrast)\$  
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $Y\$: arousal
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $B_0\$ : intercept  
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $B_1 - B_4\$ : effect of frequency band in story negative  
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $B_5\$ : General difference between story neg. and pos.(intercept)  
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $B_6 - B_9\$ : difference in the effect of frequnecy band between story neg. and pos.  

#### 2nd level
### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $\ Y = B_0 + B_1Age + B_2Sex + B_3IRI_Fantacy + B_4IRI_Perspective + B_5IRI_Empathic + B_6IRI_Distress\$
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $Y\$ : delta/theta/alpha/beta difference effect
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $B_0\$ : intercept  
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $B_1 - B_6\$ : effect of behave   

#### result
![delta_contrast](https://github.com/user-attachments/assets/782393a2-43da-4d96-8ad8-97f65cbf3ab0)
![theta_contrast](https://github.com/user-attachments/assets/fcecbf6b-83e3-49f4-9765-dc770fed99da)
![alpha_contrast](https://github.com/user-attachments/assets/8652c4b4-9d9b-4225-9ad9-f78274ce8451)
![beta_contrast](https://github.com/user-attachments/assets/1467f3c4-445b-4445-930c-e1046a36a1d7)



> [!Note]
> ### meeting
> - 在做行為資料的相關性時，Age跟其他IRI的結果有相關性，所以在2nd level中的模型可能需要加上Age跟其他IRI的interaction term
> - 正負項模型分成兩個模型跑，為了看單獨模型的影響是正還是負(只看相減看不出來)
>
> - 假設要把Y合併arousal跟pos. neg.或許可以把neg.做個鏡像(?) -8的值變成-2 總共是10 所以 10-8 = 2加上負號

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 


## 250217
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

### model
#### 1st level
### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $\ Y+ = B_0 + B_1delta + B_2theta + B_3alpha + B_4beta)\$  
### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $\ Y- = B_0 + B_1delta + B_2theta + B_3alpha + B_4beta)\$  
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $Y\$: arousal
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $B_0\$ : intercept  
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $B_1 - B_4\$ : effect of frequency band

#### 2nd level
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


#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $Y\$ : delta/theta/alpha/beta difference effect
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $B_0\$ : intercept  
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $B_1 - B_6\$ : effect of behave   

> [!Note]
> 把正負向情緒分開放跑  
>    

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 


## 250218
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

### model 2
#### 1st level
### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $\ Y = B_0 + B_1delta + B_2theta + B_3alpha + B_4beta + B_5contrast + B_6(delta * contrast) + B_7(theta * contrast) + B_8(alpha * contrast) + B_9(beta * contrast)\$  
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $Y\$: arousal
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $B_0\$ : intercept  
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $B_1 - B_4\$ : effect of frequency band in story negative  
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $B_5\$ : General difference between story neg. and pos.(intercept)  
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $B_6 - B_9\$ : difference in the effect of frequnecy band between story neg. and pos.  

##### 1st level for group 1(0 : neg. story)
### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $\ Y = B_0 + B_1delta + B_2theta + B_3alpha + B_4beta + B_5contrast\$  

##### 1st level for group 2(1 : neg. story)
### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $\ Y = (B_0+B_5) + (B_1+B_6)delta + (B_2+B_7)theta + (B_3+B_8)alpha + (B_4+B_9)beta\$  

> [!Note]
> 算完的結果數值不會跟兩個組別分開跑的結果一樣，但差異的數值不會差太多。
> B_5 > 0 代表neg.(0)對情感強度有更高的影響。
> B_5 < 0 代表pos.(1)對情感強度有更高的影響。

#### 2nd level
### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $\ Y = B_0 + B_1Age + B_2Sex + B_3IRI_Fantacy + B_4IRI_Perspective + B_5IRI_Empathic + B_6IRI_Distress\$
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $Y\$ : delta/theta/alpha/beta difference effect
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $B_0\$ : intercept  
#### &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; $B_1 - B_6\$ : effect of behave   




&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 

## 250225
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   
- this model
![image](https://github.com/user-attachments/assets/8db00414-ddfe-46a6-9610-a3b898e45fd3)

#### Intercept difference : Arousal對??頻段的影響在兩組間有沒有差異(B0)
- Age and Sex
  - delta : frontal lobe(Fp1,Fp2,F3,F4),left central parietal(CP1) and left occipital(O1)
  - theta : nan
  - alpha : right parietal(P8)
  - beta : nan
- Age, Sex, IRI_Fantasy
  - delta : central, occipital(Cz,O1,Oz)
  - theta : nan
  - alpha : parietal, occipital(P3,Oz)
  - beta : nan
- Age, Sex, IRI_Perpeptive
  - delta : occipital(O1)
  - theta : nan
  - alpha : nan
  - beta : nan
- Age, Sex, IRI_Empathic
  - delta : frontal(Fz)
  - theta : nan
  - alpha : nan
  - beta : parietal(CP6,P8)
- Age, Sex, IRI_Distress
  - delta : frontal(FC1)
  - theta : nan
  - alpha : frontal(F3)
  - beta : frontal(FC2),occipital(O2)
- conclusion : 在frontal跟occipital的位置，Delta頻段對Arousal大小的影響，會根據正向情緒或是負向情緒而有所改變

#### Age difference : Arousal對??頻段的影響在兩組間的差異，會不會受到年齡的影響(B1)
- Age and Sex
  - delta : frontal(Fp1,Fp2,F4), central(Cz), parietal(P8)
  - theta : nan
  - alpha : parietal(P8)
  - beta : nan
- Age, Sex, IRI_Fantasy
  - delta :  nan
  - theta : nan
  - alpha : parietal(P3), occipital(Oz)
  - beta : nan
- Age, Sex, IRI_Perpeptive
  - delta : occipital(O1)
  - theta : nan
  - alpha : nan
  - beta : nan
- Age, Sex, IRI_Empathic
  - delta : frontal(Fz)
  - theta : frontal(FC6), parietal(CP6,P8)
  - alpha : nan
  - beta : parietal(CP6,P8)
- Age, Sex, IRI_Distress
  - delta : frontal(FC1)
  - theta : frontal(F3)
  - alpha : nan
  - beta : frontal(FC2), occipital(O2)
- conclusion : 

#### Sex difference : Arousal對??頻段的影響在兩組間的差異，會不會受到性別的影響(B2)
- Age and Sex
  - delta : parietal(P3,P8), occipital(Oz)
  - theta : nan
  - alpha : nan
  - beta : parietal(P7)
- Age, Sex, IRI_Fantasy
  - delta : parietal(P3,P8),occipital(O1,Oz)
  - theta : nan
  - alpha : nan
  - beta : parietal(P7)
- Age, Sex, IRI_Perpeptive
  - delta : parietal(P3,P8)
  - theta : nan
  - alpha : nan
  - beta : frontal(Fz), parietal(P3)
- Age, Sex, IRI_Empathic
  - delta : parietal(P3,P8), occipital(Oz)
  - theta : nan
  - alpha : nan
  - beta : frontal(Fz)
- Age, Sex, IRI_Distress
  - delta : parietal(P3,CP1)
  - theta : nan
  - alpha : frontal(FC6), parietal(P4)
  - beta : frontal(Fz, FC2), parietal(P4,P8) 
- conclusion : 在parietal(P3,P8)的位置上，delta頻段對Arousal的影響在正負情緒的差異，會因為性別的不同而不同
  
#### IRI_Fantasy difference : Arousal對??頻段的影響在兩組間的差異，會不會跟IRI_Fantasy的分數有關(B3)
- IRI_Fantasy
  - delta : nan
  - theta : nan 
  - alpha : parietal(P3,P7),occipital(O1,Oz)
  - beta : nan
- IRI_Fantasy x Age
  - delta : nan
  - theta : nan 
  - alpha : parietal(P3,P7),occipital(O1,Oz)
  - beta : nan
- conclusion : 在parietal(P3,P7),occipital(O1,Oz)的位置上，alpha頻段對Arousal的影響在正負情緒之間的差異，會跟IRI_Fantasy的分數有關，
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; IRI_Fantasy的beta value > 0 --> alpha頻段對arousal的影響在正負情緒之間的差異越大，IRI_Fantasy的分數就越高。   
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp; IRI_Fantasy x Age 的beta value < 0 --> alpha頻段對arousal的影響在正負情緒之間的差異越大，年齡越小。年齡越小，alpha頻段越能夠影響閱讀正負向情緒的感覺?。

#### IRI_Perspective difference : Arousal對??頻段的影響在兩組間的差異，會不會跟IRI_Perspective的分數有關(B3)
- IRI_Perpeptive
  - delta : occipital(O1)
  - theta : nan
  - alpha : nan
  - beta : parietal(P3)
- IRI_Perpeptive x Age
  - delta : occipital(O1)
  - theta : nan
  - alpha : nan
  - beta : parietal(P3)
- conclusion : 在parietal(P3),occipital(O1)的位置上，delta頻段以及beta頻段對Arousal的影響在正負情緒之間的差異，會跟IRI_Fantasy的分數有關，
  
#### IRI_Empathic difference : Arousal對??頻段的影響在兩組間的差異，會不會跟IRI_Empathic的分數有關(B3)
- IRI_Perpeptive
  - delta : Fz
  - theta : nan
  - alpha : nan
  - beta : nan
- IRI_Perpeptive x Age
  - delta : Fz
  - theta : nan
  - alpha : nan
  - beta : nan
- conclusion : 
 
#### IRI_Perspective difference : Arousal對??頻段的影響在兩組間的差異，會不會跟IRI_Perspective的分數有關(B3)
- IRI_Perpeptive
  - delta : FC1,T7
  - theta : 
  - alpha : 
  - beta : FC2
- IRI_Perpeptive x Age
  - delta : FC1,T7
  - theta : 
  - alpha : F3
  - beta : FC2 O2
- conclusion

#### all 
- C3_delta IRI_perspective
- C4_alpha Age x IRI_Distress
- C4_alpha IRI_Empathic x IRI_Distress
- CP1_beta IRI_perspective
- CP2_alpha IRI_Fantasy, Age x IRI_Fantasy
- CP5_alpha IRI_Distress, Age x IRI_Distress
- CP6_alpha IRI_Distress, Age x IRI_Distress, IRI_Distress x IRI_Empathic
- F3_alpha Age x IRI_Distress, IRI_Empathic x IRI_Distress
- F3_beta IRI_Distress, Age x IRI_Fantasy, Age:IRI_Distress, IRI_Empathic:IRI_Distress
- F4_alpha IRI_Perspective x IRI_Empathic, IRI_Empathic x IRI_Distress
- F7_alpha IRI_Empathic x IRI_Distress
- F7_beta IRI_Distress
- FC1_alpha IRI_Distress, Age x IRI_Distress
- FC1_delta IRI_Distress
- FC2_beta IRI_Distress, Age x IRI_Distress
- FC5_alpha Age x IRI_Distress, IRI_Empathic x IRI_Distress
- FT10_Delta IRI_Empathic x IRI_Distress
- Fp1_alpha IRI_Empathic x IRI_Distress
- Fp2_alpha IRI_Empathic x IRI_Distress
- O1_alpha IRI_Perspective x IRI_Empathic
- O1_delta IRI_Perspective, IRI_Empathic, Age x IRI_Perspective
- Oz_beta IRI_Perspective, Age x IRI_Fantasy
- Oz_delta IRI_Distress, Age x IRI_Perspective
- P3_alpha Age x IRI_Fantasy, IRI_Perspective x IRI_Empathic
- P3_beta IRI_Perspective, Age x IRI_Perspecive
- P7_alpha IRI_Perspective x IRI_Empathic
- Pz_beta IRI_Perspective
- T7_alpha IRI_Fantasy, Age x IRI_Distress, IRI_Empathic x IRI_Distress
- T7_delta IRI_Empathic x IRI_Distress
- T8_alpha IRI_Empathic x IRI_Distress
- Tp9_alpha Age x IRI_Perspective
- 


&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 

## 250513
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

- Get frequency band : store variable "res" for every trial, contains every channel and their abs bandpower, rel bandpower, ersp bandpower.
- plot PSD for every trial. plot all channel in one figure.
- 目前大致上看一下PSD的圖，發現在 O1,Oz,O2,P4的位置，大多在右側，左側偶爾有，有一個5Hz的peak，大概在偏後側的位置C,CP,P的部分10Hz會比較明顯。
- q06,q01 : 部分5Hz的peak不明顯

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 


## 
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 


## 
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 


## 
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 


## 
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 


## 
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 


## 
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 


## 
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 


## 
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 


## 
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 


## 
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 


## 
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 


## 
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 

## 
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 



