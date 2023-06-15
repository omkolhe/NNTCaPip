
fn = 'filename';
writerobj = VideoWriter([fn '.avi'],'Uncompressed AVI'); % Initialize movie file
writerobj.FrameRate = 30;
open(writerobj);

examTrace = [36 35 101 45 100 71 44 55 12 22 52 56 15];
figure,
ax1 = subplot(211);stack_plot(DeltaFoverF(examTrace,:),1,5,1);set(gca,'Color','k')
ax2 = subplot(212);plot(Behaviour.time/1000,smoothdata(abs(Behaviour.leverTrace-285),'gaussian',25),'w');
box off;ylim([0 40]);set(gca,'Color','k')
writeVideo(writerobj,getframe(gcf)); %grabs current fig frame
for i= 100:0.033:150
    ax1.XLim = [i-15 i+15];
    ax2.XLim = [i-15 i+15];
% pause(0.01)
writeVideo(writerobj,getframe(gcf)); %grabs current fig frame
% drawnow
end


