% SETFIELDS Muuttaa useamman solmun struktuurin alkioita.
% MeshNodes = SETFIELDS(MeshNodes, indlist, field, value)
%
%   MeshNodes on cell-array MeshNode-rakenteita, jotka kuvaavat
%   siksak-graafin solmuja. T�m� saadaan yleens� funktioilla 
%   CREATE_MESH_NODES ja MESH_CONNECT_NODES.
%
%   indlist on vektori solmujen indeksej�, joita vastaavien
%   rakenteiden alkioita haluamme muuttaa.
%
%   value on arvo, jonka muutetuille alkoille haluamme antaa.
%
%   Funktio palauttaa p�ivitetyn MeshNodes-cellarrayn.

function Mn= setfields(Mn, indlist, field,  value)

for ind=1:length(indlist)
    Mn{indlist(ind)} = setfield(Mn{indlist(ind)}, field, value);
end