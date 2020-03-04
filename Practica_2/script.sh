#!/bin/bash

echo "Media1"
for i in $(seq 1 8); do
rm media1
gcc -x assembler-with-cpp -D TEST=$i -no-pie media1.s -o media1
echo -n "T#$i "; ./media1
done

echo "Media2"
for i in $(seq 1 14); do
rm media2
gcc -x assembler-with-cpp -D TEST=$i -no-pie media2.s -o media2
echo -n "T#$i "; ./media2
done

echo "Media3"
for i in $(seq 1 19); do
rm media3
gcc -x assembler-with-cpp -D TEST=$i -no-pie media3.s -o media3
echo -n "T#$i "; ./media3
done
