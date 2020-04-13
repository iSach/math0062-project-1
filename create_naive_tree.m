function tree = create_naive_tree(balls_in_urn,nb_draws,replacement)

% This function retruns the tree of events for the urn problem.
%
% Input:
%     balls_in_urn    vector of numeric, logical, or char values containing
%                     the list of balls in the urn
%     nb_draws        positive integer = number of balls drawn from the urn
%     replacement     logical flag:
%                       - true if with replacement
%                       - false if without replacement
%
% Output:
%     tree            k-by-nb_draws array of numeric, logical, or char values
%                     containing the list of k events for the urn problem.
%                     The number k of possible events depends on the number
%                     of draws and on the method of sampling (replacement or not).
%                     Each column represents a level of the tree. The first column
%                     is the first level, ..., the last column is the last level
%                     (leaves of the tree).
%
% Example:
%     tree = create_naive_tree('RRGGBB',3,false)
%     tree = create_naive_tree([1:10],4,true)

balls_in_urn = balls_in_urn(:) ;

I = maketree(length(balls_in_urn),nb_draws,replacement) ;
tree = balls_in_urn(I) ;

    function I = maketree(nb_balls,nb_draws,replacement)
        
        if nb_draws == 1
            
            I = 1:nb_balls ;
            I = I(:) ;
            
        else
            
            rec  = maketree(nb_balls,nb_draws-1,replacement);
            
            nsub = nb_balls - nb_draws + 1;
            I = zeros(size(rec,1)*nsub,size(rec,2)+1) ;
            for k=1:size(rec,1)
                balls_in_suburn = 1:nb_balls ;
                if not(replacement)
                    balls_in_suburn(rec(k,:)) = [] ;
                end
                I(length(balls_in_suburn)*(k-1)+(1:length(balls_in_suburn)),:) = [repmat(rec(k,:),length(balls_in_suburn),1),balls_in_suburn(:)];
            end
            
        end
    end

end