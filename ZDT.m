function z=ZDT(n)
    
    data;

    ni = floor(MTTF./(n*T));
    bb = T/3;
    % Reliability
    Rp = exp(-ni.*(T./MTTF).^b).*exp((-1)*(bb./MTTF).^b);
    Up = 1- Rp;
   
    Ru = zeros(1,7);
    Ru(1) = 1-Up(8)*Up(9);
    Ru(2) = 1-Up(1)*Up(6);
    Ru(3) = 1-Up(2)*Up(3);
    Ru(4) = 1-Up(4)*Up(8);
    Ru(5) = 1-Up(5)*Up(9);
    Ru(6) = 1-Up(7);
    Ru(7) = 1-Up(10);
    
    % FOSS Unavaibility
    U = 1 - prod(Ru);
   
    % Maintenance Cost
    
    dd = numel(n);
    
    Cp = 0;
    
    for ii = 1:dd
        if (Rp(ii) > tr) % Cost Without Replacement
            Cp = Cp + n(ii)*Cpp(ii) + Cc(ii);
        
        else % Cost With Replacement
            Cp = Cp + Rc(ii) + Cc(ii);
        end
    end
    
    z=[U
       Cp];

end