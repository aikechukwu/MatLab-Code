function b=Dominates(x,y)

    if isstruct(x) && isfield(x,'Cost')
        x=x.Cost;
    end

    if isstruct(y) && isfield(y,'Cost')
        y=y.Cost;
    end

    b=all(x<=y) && any(x<y);
    
end
