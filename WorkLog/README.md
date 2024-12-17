## content
[2024/12/02 Before](#241202_1)   
- start with convert file type and preprocessing to epoch Data   
[2024/12/02](#241202_2)
- get reading timing   
[2024/12/05](#241205)
- using wavelet transform to get freqeuncy band     
[2024/12/06](#241206)
- statistical    
[2024/12/10](#241210)  
- statistical two sample cluster fdr   
[2024/12/11](#241211)  
- statistical GLM  
[2024/12/12](#241212)   
- arrange event data using raw(?close) event file    
[2024/12/17](#241217)   
- rearrage run process merge all file first --> aim to get trial     

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
- ##### change in epoch_Data function
  - epoch_Data : `add reading trial .xlsx and event file`  
   &ensp;&ensp;&ensp;&ensp;&ensp; `line 98 : suppose trial .xlsx type 31 number - event type 22 index is 1`  
   &ensp;&ensp;&ensp;&ensp;&ensp;`line 103 : read trial file condition2 if is 99 then this trial are removed`  
  - for event file : `want to using edat file(.xlsx) to get event file, but some of subject edat file has been changed`  
   &ensp;&ensp;&ensp;&ensp;&ensp; `so using a "if" in epoch_Data read event file (line 155) to check event file row is 72 or not,`  
   &ensp;&ensp;&ensp;&ensp;&ensp; `if not check is same as trial file row length`,  
   &ensp;&ensp;&ensp;&ensp;&ensp; `if not then give users to check`  
  
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 

## 
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 


## 
&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content)   

&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;[content](#content) 

