% This function calculate the water provide given the power Q and
% temperature T
function Wp=Waterprovide(Qwp,T)
global V
global Td
%global Wd

%initial water provide
Wp=zeros(1,24);

for i=1:24
    if i == 1;
        Tchoose = Td;
    else
        Tchoose = T(i-1);
    end
    
      
    if Tchoose >110
        Wp(i)=(V*0.7)*(Tchoose-50)/60+ Qwp(i)/(2.442*(110-50));
    else
        Wp(i)=Qwp(i)/(2.442*70)*(Tchoose+20)/60;
         %y(i)= k*Q./(2.44*70)*(i+20)/60;
  
    end
end


