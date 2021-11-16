global binaryImgVector BinaryinformationReciver;
%Valor de M array para la modulación QAM
M = 4;
nbit=length(binaryImgVector); % cantidad de bits de información muestra
msg=binaryImgVector;
%Representación de la transmisión de información binaria como señal digital
x=msg;
bp=.000001;
bit=[]; 
for n=1:1:length(x)
    if x(n)==1;
       se=ones(1,100);
    else x(n)==0;
        se=zeros(1,100);
    end
     bit=[bit se];

end
t1=bp/100:bp/100:100*length(x)*(bp/100);
% La información binaria se convierte en forma simbólica para la modulación QAM M-array
M=M;
msg_reshape=reshape(msg,log2(M),nbit/log2(M))';

size(msg_reshape);
for(j=1:1:nbit/log2(M))
   for(i=1:1:log2(M))
       a(j,i)=num2str(msg_reshape(j,i));
   end
end

as=bin2dec(a);
ass=as';

% Mapeo para modulación QAM de matriz M
M=M;              
x1=[0:M-1];
p=qammod(ass,M)    %diseño de constalación para QAM M-array según símbolo
sym=0:1:M-1;       
pp=qammod(sym,M);  %diagrama de constatación para M-array QAM         

%Modulación QAM M-array
RR=real(p)
II=imag(p)
sp=bp*2; 
sr=1/sp;   % velocidad de símbolo
f=sr*2;
t=sp/100:sp/100:sp;
ss=length(t);
m=[];
for(k=1:1:length(RR))
    yr=RR(k)*cos(2*pi*f*t);  
    yim=II(k)*sin(2*pi*f*t); 
    y=yr+yim;
    m=[m y];
end
tt=sp/100:sp/100:sp*length(RR);

%Demodulación QAM M-array
m1=[];
m2=[];
for n=ss:ss:length(m)
  t=sp/100:sp/100:sp;
  y1=cos(2*pi*f*t);
  y2=sin(2*pi*f*t);
  mm1=y1.*m((n-(ss-1)):n);                                    
  mm2=y2.*m((n-(ss-1)):n);                                    
  z1=trapz(t,mm1)  
  z2=trapz(t,mm2) 
  zz1=round(2*z1/sp)
  zz2=round(2*z2/sp)
  m1=[m1 zz1]
  m2=[m2 zz2]
end

%Desasignación para la modulación QAM M-array
clear i;
clear j;
for (k=1:1:length(m1))  
gt(k)=m1(k)+j*m2(k);
end
gt

ax=qamdemod(gt,M);
figure(1);
subplot(2,1,1);
stem(ax,'linewidth',2);
title(' Volver a obtener los símbolo después de la demodulación QAM en el receptor');
xlabel('n(discrete time)');
ylabel(' magnitude');

bi_in=dec2bin(ax);
[row col]=size(bi_in);
p=1;
 for(i=1:1:row)
     for(j=1:1:col)
         re_bi_in(p)=str2num(bi_in(i,j));
         p=p+1;
     end
 end 

%representación de recibir información binaria como señal digital
x=re_bi_in;
BinaryinformationReciver=x;
bp=.000001;
bit=[]; 
for n=1:1:length(x)
    if x(n)==1;
       se=ones(1,100);
    else x(n)==0;
        se=zeros(1,100);
    end
     bit=[bit se];

end
t1=bp/100:bp/100:100*length(x)*(bp/100);
figure(1)
subplot(2,1,2);
plot(t1,bit,'lineWidth',2.5);grid on;
axis([ 0 bp*length(x) -.5 1.5]);
ylabel('amplitude(volt)');
xlabel(' time(sec)');
title('Información recibida - Señal digital después de la demodulación binaria QAM');

