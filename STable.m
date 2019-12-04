dd = PF;
sw.q = 'af(0) bp(0) cp(0) fm(0) ht(0) if(0) me(0) mt(0) st(0) vm(0)';
field = {'S','R','sigma','sigmaK','D','F'};
ff = rmfield(dd,field);

clear M
M.Combination = [];
M.Unavailability = [];
M.Cost = [];
M.Generation = [];
for jj = 1:length(ff)
    M(jj).Combination = sw.q;
    M(jj).Unavailability = ff(jj).Cost(1);
    M(jj).Cost = ff(jj).Cost(2);
    M(jj).Generation = ff(jj).G;
    bb = 0;
    for kk = 4:6:58
        bb = bb + 1;
        M(jj).Combination(kk) = int2str(ff(jj).Position(bb));
    end
end
