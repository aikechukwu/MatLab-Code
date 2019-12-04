function p=BinaryTournamentSelection(pop,f)

    n=numel(pop);
    
    I=randsample(n,2);
    
    i1=I(1);
    i2=I(2);
    
    if f(i1)<f(i2)
        p=pop(i1);
    else
        p=pop(i2);
    end

end
