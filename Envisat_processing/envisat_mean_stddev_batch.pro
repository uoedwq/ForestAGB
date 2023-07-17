pro ENVISAT_mean_stddev_batch

compile_opt strictarr
COMPILE_OPT idl2

envi, /restore_base_save_files
envi_batch_init, log_file='batch.txt',/NO_STATUS_WINDOW

dir0='D:\'   ; input path .tif
out_dir='D:\'  ; output path

files=file_search(dir0,'*.tif')

num = n_elements(files)  

  xsize = 720L
  ysize = 720L

  means = make_array(xsize,ysize);mean
  std = make_array(xsize,ysize)
  stack = fltarr(xsize,ysize, n_elements(files))
  
 
for i=0,n_elements(files)-1 do begin
  
  inputfile=files[i]

  inputfilesplit = strsplit(inputfile,'\',/extract) ; use '\' to break the string and extract string,
  imagename=inputfilesplit[N_ELEMENTS(inputfilesplit)-1];use the string after the last '\' as output filename

  inputfilesplit = strsplit(imagename,'_',/extract) ; use '\' to break the string and extract string,
  m = inputfilesplit[0]
  n = inputfilesplit[1]
  
  for e=252,313 do begin
    for f=036,071 do begin

      if e eq m then begin
        if f eq n then begin
          print,[m,n]
       
        ENVI_OPEN_FILE, files[i], r_fid=fid,  /no_realize
        ENVI_FILE_QUERY, fid,  nl=nl, ns=ns,dims=dims,nb=nb
        mapinfo=envi_get_map_info(fid=fid)
        file=ENVI_GET_DATA(fid=fid,dims=dims,pos=0)
;        stack[*,*,i] = file[where(file gt 0, /NULL)]
        stack[*,*,i] = file
        
        means = mean(stack,dimension=3)
        standarddev = STDDEV(stack, dimension=3)
        
             
        outfile_mean = out_dir + '\' + strmid(file_basename(files[i]),0,7) + '_mean.tif'    ;16  25
        outfile_std = out_dir + '\' + strmid(file_basename(files[i]),0,7) + '_std.tif'
        ENVI_WRITE_ENVI_FILE , means , r_fid=fid , map_info=mapinfo , out_name=outfile_mean
        ENVI_WRITE_ENVI_FILE , standarddev , r_fid=fid , map_info=mapinfo , out_name=outfile_std
       
              
        endif
      endif
       
     endfor
   endfor      

 endfor

    

end