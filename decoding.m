function decoded_message = decoding(myGrayImage, mapset, block_size)
    [rows, cols] = size(myGrayImage);
    
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
        
    best_col = idx_best_block(1);
    best_row = idx_best_block(2);
    
    
    extracted_bits = '';
    for r_offset = 0:(block_size - 1)   
        for c_offset = 0:(block_size - 1)  
            r = best_row + r_offset;
            c = best_col + c_offset;
            
            bit_val = bitget(myGrayImage(r, c), 1);
            extracted_bits = [extracted_bits, num2str(bit_val)];
        end
    end
        
    
    decoded_message = '';
    current_bits = '';
        
    for i = 1:length(extracted_bits)
        current_bits = [current_bits, extracted_bits(i)];
        
        idx = find(strcmp(mapset(2,:), current_bits));
        
        if ~isempty(idx)
            char_found = mapset{1, idx(1)};
            decoded_message = [decoded_message, char_found];
            current_bits = ''; 
            
            
            if char_found == ';'
                break;
            end
        end
    end
        
    
    figure;
    imshow(myGrayImage);
    text(best_col, max(1, best_row - 15), decoded_message, 'Color', 'red', 'FontSize', 14, 'FontWeight', 'bold');
end
