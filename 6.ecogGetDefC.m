function C=ecogGetDefC(TRAIN)

% determine default C according to Joachims
scalar_prod=zeros(1,size(TRAIN,1));
for f=1:length(scalar_prod), 
     scalar_prod(f)=TRAIN(f,:)*TRAIN(f,:)';
end
C=1/mean(scalar_prod);
