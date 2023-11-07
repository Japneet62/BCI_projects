function plotRawGesture(gloveResamp)

load gloveResamp_Dav_2011_9_7_14_28_21.mat

timebase = linspace(1,length(gloveResamp.timebase{1})/200,length(gloveResamp.timebase{1}));

figure
subplot(2,1,1)
plot(timebase,gloveResamp.fingers{2,1},'k','linewidth',2);
hold on
plot(timebase,gloveResamp.fingers{4,1},'b','linewidth',2);
plot(timebase,gloveResamp.pitch{1},'r','linewidth',2);
plot(timebase,gloveResamp.roll{1},'g','linewidth',2);

xlim([10 85])
ylabel('Amplitude []','Fontweight','bold','Fontsize',20)
legend('Hand/Fist','Finger','Pitch','Roll')

subplot(2,1,2)
plot(timebase,gloveResamp.acceleratorsXYZ{1,1},'r','linewidth',2);
hold on
plot(timebase,gloveResamp.acceleratorsXYZ{2,1},'b','linewidth',2);
plot(timebase,gloveResamp.acceleratorsXYZ{3,1},'g','linewidth',2);

xlim([10 85])
xlabel('Time [s]','Fontweight','bold','Fontsize',20)
ylabel('Amplitude [g]','Fontweight','bold','Fontsize',20)
legend('X','Y','Z')