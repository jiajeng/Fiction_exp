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
![delta](https://github.com/user-attachments/assets/5068eae5-7afb-4e83-8ee7-c32014882642)  
![theta](https://github.com/user-attachments/assets/8aadc4ae-1e6e-4a9c-82ea-faccd35e8857)  
![alpha](https://github.com/user-attachments/assets/f4f84edd-b134-4bfa-873b-db29d486ac6b)  
![beta](https://github.com/user-attachments/assets/452bb23e-6902-4cd8-8179-0e6678508b80)  

![delta_contrast](https://github.com/user-attachments/assets/782393a2-43da-4d96-8ad8-97f65cbf3ab0)
![theta_contrast](https://github.com/user-attachments/assets/fcecbf6b-83e3-49f4-9765-dc770fed99da)
![alpha_contrast](https://github.com/user-attachments/assets/8652c4b4-9d9b-4225-9ad9-f78274ce8451)
![beta_contrast](https://github.com/user-attachments/assets/1467f3c4-445b-4445-930c-e1046a36a1d7)



&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 


## 
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 


## 
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 


