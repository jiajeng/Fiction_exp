## content
[2024/12/02 Before](#241202_1)  
[2024/12/02](#241202_2)

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

