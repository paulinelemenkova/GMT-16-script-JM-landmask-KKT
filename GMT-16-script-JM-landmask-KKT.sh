#!/bin/sh
# Purpose: Land mask (land vs water) of the shorelines in the Kuril-Kamchatka Trench area
# GMT modules: grdcut, makecpt, grdlandmask, grdimage, grdcontour, psbasemap, gmtlogo, psconvert
# Step-1. Generate a file
ps=KKT_land_mask.ps
# Step-2. Extract a subset of ETOPO1m for the Kuril-Kamchatka Trench area
grdcut earth_relief_01m.grd -R140/170/40/60 -Gkkt_relief.nc
# Step-3. Make color palette
gmt makecpt -Cbermuda.cpt -V -T-10000/1000 > myocean.cpt
# Step-4. Make land mask
gmt grdlandmask -R140/170/40/60 -Df -I5m -N1/NaN -Gland_mask.nc -V
# Step-5. Visualize land mask
gmt grdimage land_mask.nc -Cmyocean.cpt -R140/170/40/60 -JM6i -P -I+a15+ne0.75 -Xc -K > $ps
# Step-6. Add shorelines
gmt grdcontour kkt_relief.nc -R -J -C1000 -O -K >> $ps
# Step-7. Add grid
gmt psbasemap -R -J \
	--FORMAT_GEO_MAP=dddF \
	--MAP_FRAME_PEN=dimgray \
	--MAP_FRAME_WIDTH=0.1c \
    --MAP_TITLE_OFFSET=0.5c \
	--MAP_TICK_PEN_PRIMARY=thinner,dimgray \
    --MAP_GRID_PEN_PRIMARY=thin,dimgray \
    --MAP_GRID_PEN_SECONDARY=thinnest,dimgray \
	--FONT_TITLE=12p,Palatino-Roman,black \
	--FONT_ANNOT_PRIMARY=7p,Helvetica,dimgray \
	--FONT_LABEL=7p,Helvetica,dimgray \
    -Bpxg8f2a4 -Bpyg6f3a3 -Bsxg4 -Bsyg3 \
    -B+t"Land mask (land vs water) of the shorelines in the Kuril-Kamchatka Trench area" -O -K >> $ps
# Step-8. Add scale, directional rose
gmt psbasemap -R -J \
    --FONT=8p,Palatino-Roman,dimgray \
    --MAP_ANNOT_OFFSET=0.0c \
    -Tdx1.0c/13.3c+w0.3i+f2+l+o0.15i \
    -Lx5.3i/-0.5i+c50+w500k+l"Mercator projection. Scale (km)"+f \
    -UBL/-15p/-40p -O -K >> $ps
# Step-9. Add GMT logo
gmt logo -Dx6.2/-2.2+o0.1i/0.1i+w2c -O >> $ps
# Step-11. Convert to image file using GhostScript
gmt psconvert KKT_land_mask.ps -A0.2c -E720 -Tj -Z
