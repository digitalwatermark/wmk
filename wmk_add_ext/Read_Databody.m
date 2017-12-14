
function [acqdata] = Read_Databody()
globalvar_realtime_wmkextractor;

tempdata =[];
temp=zeros(Algorithm_Param.N,2);

count = count+1;
hslider = Hplot(9);
set(hslider,'value',count/t.TasksToExecute);

if ~feof(readfileID)  
    file_over=0;
    if(ReadInital)
        chartmp1 =  fread(readfileID,1,'uint8');
        chartmp2 =  fread(readfileID,1,'uint8');
        chartmp3 =  fread(readfileID,1,'uint8');
        chartmp4 =  fread(readfileID,1,'uint8');
        while( chartmp1~=100 || chartmp2~=97 || chartmp3~=116  || chartmp4~=97)
        %while( chartmp1~=109 || chartmp2~=100 || chartmp3~=97  || chartmp4~=116)
            chartmp1 =  fread(readfileID,1,'uint8');
            chartmp2 =  fread(readfileID,1,'uint8');
            chartmp3 =  fread(readfileID,1,'uint8');
            chartmp4 =  fread(readfileID,1,'uint8');
         end;

        chartmp1= fread(readfileID,1,'uint8');
        chartmp2 =  fread(readfileID,1,'uint8');
        chartmp3 =  fread(readfileID,1,'uint8');
        chartmp4 =  fread(readfileID,1,'uint8');
        ReadInital=0;
%         Readdata = fread(readfileID,Algorithm_Param.N*2,'short');
        Readdata = fread(readfileID,Algorithm_Param.N*2*overtime,'short'); 
    else  
%         Readdata = fread(readfileID,Algorithm_Param.N*2,'short');   
        Readdata = fread(readfileID,Algorithm_Param.N*2*overtime,'short'); 
    end
    tempdata(:,1) = Readdata(1:2:end-1)/65536;
    tempdata(:,2) = Readdata(2:2:end)/65536;
    for j=1:overtime
       temp(:,:) = temp(:,:) + tempdata(Algorithm_Param.N*(j-1)+1 : Algorithm_Param.N*j,:);
    end
    acqdata(:,:) = temp(:,:);

%     acqdata(:,1) = Readdata(1:2:end-1)/65536;
%     acqdata(:,2) = Readdata(2:2:end)/65536;
else
    fseek(readfileID,0,'bof');
    ReadInital = 1;
    acqdata = 0;
    stop(t);
    delete(t);
    msgbox('检测完成。','提示');
end;





    

