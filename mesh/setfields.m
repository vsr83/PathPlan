% SETFIELDS Muuttaa useamman solmun struktuurin alkioita.
% MeshNodes = SETFIELDS(MeshNodes, indlist, field, value)
%
%   MeshNodes on cell-array MeshNode-rakenteita, jotka kuvaavat
%   siksak-graafin solmuja. Tämä saadaan yleensä funktioilla 
%   CREATE_MESH_NODES ja MESH_CONNECT_NODES.
%
%   indlist on vektori solmujen indeksejä, joita vastaavien
%   rakenteiden alkioita haluamme muuttaa.
%
%   value on arvo, jonka muutetuille alkoille haluamme antaa.
%
%   Funktio palauttaa päivitetyn MeshNodes-cellarrayn.

function Mn= setfields(Mn, indlist, field,  value)

for ind=1:length(indlist)
    Mn{indlist(ind)} = setfield(Mn{indlist(ind)}, field, value);
end