function secretImage = coding(message, myGrayImage, mapset)
    
    if message(end) ~= ';'
            message = [message, ';'];
    end
    
    
    message2binary = [];

    for i = 1:length(message)
        finded_character = find(strcmp(cellstr(mapset(1,:)), message(i)));
        message2binary = [message2binary,mapset{2,finded_character}];
    end

    
   
    [rows, cols] = size(myGrayImage);
    block_size = 10; 
    
    max_blockVar = -1; 
    idx_best_block = [1, 1];
    
    
    for n = 1:block_size:(rows-block_size+1) 
        for m = 1:block_size:(cols-block_size+1)
            
        block = myGrayImage(n:n+block_size-1, m:m+block_size-1);
        
        block_stable = bitset(block, 1, 0);
        
        blockVar = var(double(block_stable(:)));
            
            if blockVar > max_blockVar
                max_blockVar = blockVar;
                idx_best_block = [m, n];
            end
        
        end
    end
    
   
    if length(message2binary) > block_size^2
        error('length of the message should be shorter')
    end
    
    best_col = idx_best_block(1);
    best_row = idx_best_block(2);
    
    secretImage = myGrayImage; 
    
    
    bit_counter = 1;
    for r_offset = 0:(block_size - 1)   
        for c_offset = 0:(block_size - 1)  
            r = best_row + r_offset;
            c = best_col + c_offset;
            if bit_counter <= length(message2binary)
                bit_val = str2double(message2binary(bit_counter));
                secretImage(r, c) = bitset(secretImage(r, c), 1, bit_val);
                bit_counter = bit_counter + 1;
            end
        end
    end
    
    imwrite(secretImage, 'stego_image.png');
    
    figure;
    subplot(1,2,1); imshow(myGrayImage); title('Original Image');
    subplot(1,2,2); imshow(secretImage); title('Image with Hidden Message');
end
