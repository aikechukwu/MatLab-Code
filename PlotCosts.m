function PlotCosts(PF)

    PFC=[PF.Cost];
    plot(PFC(1,:),PFC(2,:),'o','MarkerEdgeColor','b',...
    'MarkerFaceColor','b');
    ylabel('Cost')
    xlabel('Unavailability')
    grid on;
    
end
