function [A,D]=a_trous_dwt(I,N)
B3=[1/16 1/4 3/8 1/4 1/16];
h=B3'*B3;
A=double(I);
for level = 1:N
    approx(:,:,level)=conv2(A,h,'same');
    D(:,:,level)=A-approx(:,:,level);
    A=approx(:,:,level);
end
end