% POLYC_TOGRAPH muuntaa murtoviivan graafiksi, jonka solmut
% ovat murtoviivan k‰rki‰ tai janojen leikkauksia ja kaaret itse
% murtoviivan mukaisia.
%   [N, E] = POLYC_TOGRAPH(PC, vis)
%   [N, E] = POLYC_TOGRAPH(PC)
%
%   PC on nx2 matriisi, joka kuvaa murtoviivaa.
%
%   Jos vis = 1, graafi piirret‰‰n ruudulle.
%
%   Funktio palauttaa matriisit N ja E. 
%   N on nx3 matriisi, jonka rivit ovat muotoa [ind x y], miss‰
%   x ja y vastaavat rivin kuvaaman solmun koordinaattia ja ind
%   indeksi‰.
%
%   E on harva symmetrinen nxn graafi, joka m‰‰ritt‰‰ graafin
%   kaaret.


function [Nodes, Edges] = polyc_tograph(P, vis)

L = {};
if nargin == 1
    vis = false;
end

if vis
    clf
    hold on
end
    
[nseg, cols] = size(P);

% Muunnetaan P matriisiksi janoja ja haetaan niiden leikkaukset:
S = [];
for ind_S = 1:nseg-1
    S = [S; P(ind_S, :) P(ind_S+1, :)];
end
S = [S; P(nseg, :) P(1, :)];

[I, XY] = segments_intersections(S);
[nI, tmp] = size(XY);

% Seuraavaksi haluamme rakentaa graafin janoista, jotka saadaan
% P:n janat ositettaessa leikkauspisteiden mukaan.

% Solmut ovat unioni P:n k‰rjist‰ sek‰ vastaavien janojen 
% leikkauspisteist‰.
nseg
XY
nI
P

if nI == 0
    Nodes = [zeros(nseg, 1) P];
    nnodes = nseg;
    
    Edges = sparse(nnodes, nnodes);
    for ind_nodes = 1:nnodes
        ind_next = mod(ind_nodes, nnodes) + 1;
        Edges(ind_nodes, ind_next) = 1;
        Edges(ind_next, ind_nodes) = 1;
    end
    return;
end

Nodes = [zeros(nseg, 1) P; (1:nI)', XY(:, 3:4)];

if vis
    plot(Nodes(:, 2), Nodes(:, 3), 'ro');
end
    
% Muodostamamme kaaret varastoidaan nxn-matriisissa, miss‰ n on graafin
% solmujen m‰‰r‰.
[nnodes, tmp]= size(Nodes);
%nnodes
%Edges = zeros(nnodes);
Edges = sparse(nnodes, nnodes);


% XY on muotoa [ ind_suurempi, ind_pienempi, x, y ; ... ].

for ind_S = 1:nseg
    ind_next = mod(ind_S, nseg) + 1;
    startp = P(ind_S, :);    
    endp   = P(ind_next, :);

    % K‰yd‰‰n l‰pi kaikki janat ja tutkitaan matriisista XY mitk‰
    % janojen leikkauksista kuuluvat t‰ll‰ hetkell‰ k‰sitett‰v‰ll‰ 
    % janalle ind_S. N‰in indeksoimalla saamme XY:st‰ oleelliset
    % leikkauspisteet uuteen matriisiin XY2.    
    
    f1 = find(XY(:, 1) == ind_S);
    f2 = find(XY(:, 2) == ind_S);
    XY2 = XY([f1;f2], :);
    [nP, tmp] = size(XY2);
    
    % Haetaan n‰iden pisteiden sek‰ janan ind_S alku- ja loppupisteiden 
    % et‰isyydet janan ind_S alkupisteest‰ ja j‰rjestet‰‰n kyseiset
    % pisteet matriisiin pp et‰isyyksien mukaan.
    pp = [startp, 0 ind_S; endp, norm(startp-endp) ind_next];    
    for ind_P = 1:nP
        p = XY2(ind_P, 3:4);
        pp =[pp; p norm(p-startp) 1];
    end
    pp = sortrows(pp, 3);
    
    % Asetetaan edell‰ saadut pp:n janat graafin kaariksi.
    [nS, tmp] = size(pp);
    for ind_pp = 1:nS-1
        startnode = findvec(Nodes(:, 2:3), pp(ind_pp, 1:2));
        endnode   = findvec(Nodes(:, 2:3), pp(ind_pp+1, 1:2));
        Edges(startnode, endnode) = 1;
    end
end


Edges = Edges + Edges';

if vis
    gplot(Edges, Nodes(:, 2:3));
    hold on
    for ind_N = 1:nnodes
        s = sprintf(' %d', ind_N);
        text(Nodes(ind_N, 2), Nodes(ind_N, 3), s);
    end
end
