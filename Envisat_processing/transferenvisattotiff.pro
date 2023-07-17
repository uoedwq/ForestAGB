Pro transferENVISATtoTiff

  compile_opt IDL2
  envi = envi(/headless) ; Launch the application
  ;envi, /restore_base_save_files

  
  dir0='\input' 
  file=file_search(dir0,'*.ortho.short')
  
  num = n_elements(file) 
   
  for j=0,num-1 do begin  
    inputfile=file[j] 
    
    inputfilesplit = strsplit(inputfile,'\',/extract) ; use '\' to break the string and extract string,
    imagename=inputfilesplit[N_ELEMENTS(inputfilesplit)-1];use the string after the last '\' as output filename
    
    inputfilesplit = strsplit(imagename,'_',/extract) ; use '_' to break the string and extract string,
    upleft_x = inputfilesplit[0]-180 ;a
    upleft_y = 90-inputfilesplit[1] ;b
    mc= [0,0,upleft_x,upleft_y] ;Set the map tie point for the upper-left corner of the first pixel[0,0,,] to 41 degrees north, 94.00 east (-94D indicates west)
    ps = [1D/720, 1D/720] ; Pixel size
    datum = 'WGS-84'
    mapInfo =  envi_map_info_create(DATUM=datum,/GEOGRAPHIC, MC=mc, PS=ps)
    ENVI_SETUP_HEAD, fname=file[j], ns=720, nl=720, nb=1, data_type=2, $
                     offset=0, interleave=0, xstart=1, ystart=1, byte_order = 1, bnames=bnames, $ ;DATA_IGNORE_VALUE = -9999.0
                     sensor_type=sensor_type, map_info=mapInfo , /write
    raster1 = envi.OpenRaster(inputfile,DATA_IGNORE_VALUE=0)
   
      
    ;output
    filepath_output = 'C:\Envisat\1_2008\2_tif\'+imagename+'.tif' 
    raster1.Export, filepath_output, 'tiff'
    print,FORMAT='(%"%d/%d complete!")',j+1,num 
  endfor
end