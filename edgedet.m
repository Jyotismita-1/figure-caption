function J=edgedet(I,N)
%undecimated wavelet transform
H=(rgb2gray(I));
%%Convert to binary image
% L = medfilt2(H,[3 3]);
% threshold = graythresh(L);
% BW =~im2bw(L,threshold);
[approx, detail]=a_trous_dwt(H,N);
%mod of the wavelet detail coefficient
D=abs(detail(:,:,N));
% segment the mod coefficient matrix
J=(D>filter2(ones(3)/9,D)).*(D>mean2(D));
[R,C]=size(J);
J(1:3,:)=0;
J(R-2:R,:)=0;
J(:,1:3)=0;
J(:,C-2:C)=0;
end