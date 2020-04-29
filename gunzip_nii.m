%  Decompress a .nii.gz/.hdr.gz/.img.gz file, either in MATLAB or Octave
%
%  By default, Octave uses the system gzip,
%  which removes the original file during decomression.
%
%  However, we want to extract to a temporary directory
%  and keep the original, so instead we decompress to a 
%  stream and pipe to the temp file.
%
%
%  Usage: [filename] = gunzip_nii(filename, directory)
%
%  filename - NIfTI / Analyze file name
%
%  directory - Directory to extract file
%
%
%  Returned values:
%
%  filename - Path to decompressed image
%
%  Ari Kahn (ariekahn@gmail.com)
%
function [filename] = gunzip_nii(filename, directory)
    % Use custom routine if Octave
    if isOctave()
        [pathtmp, nametmp, exttmp] = fileparts(filename);
        % -d: decompress
        % -f: force overwrite
        % -c: write to stdout
        [status, cmdout] = system(['gzip -d -f -c ' filename ' > ' fullfile(directory, nametmp)]);
        % Make sure it was successful
        if status > 0
            disp(cmdout);
            error('gzip encountered an error.');
        else
            filename = fullfile(directory, nametmp);
        end
    % Otherwise use standard MATLAB gunzip
    else
        filename = gunzip(filename, directory);
    end

    return