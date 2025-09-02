# -*- coding: utf-8 -*-
"""
Created on Tue Sep 02 19:00:00 2025

@author: Laboratorio de Control
"""

import serial
import struct
import time
import csv
import numpy as np
import matplotlib.pyplot as plt

# Configurar puerto y baudrate
PORT = "COM10"
BAUDRATE = 115200

# Inicializar listas para guardar los datos recibidos y graficar
y = np.zeros((6,1000)) # 6 variables: ax, ay, az, gx, gy, gz
x = np.arange(0,1000)  # vector de indices para graficar: [0,...,1000]

# 
plt.ion()
 
# Crear la figura que vamos a ir actualizando con los datos
figure, (ax1, ax2) = plt.subplots(2,1,figsize=(10, 10))

# subfigura 1: ax, ay, az
line11, = ax1.plot(x, y[0,:], color='r') # ax
line12, = ax1.plot(x, y[1,:], color='g') # ay
line13, = ax1.plot(x, y[2,:], color='b') # az
ax1.legend(["ax","ay","az"])
ax1.set_ylim([-15,15])
ax1.grid(True)
ax1.set_ylabel("Aceleraciones")

# subfigura 2: gx, gy, gz
line21, = ax2.plot(x, y[3,:], color='r')
line22, = ax2.plot(x, y[4,:], color='g')
line23, = ax2.plot(x, y[5,:], color='b')
ax2.legend(["gx","gy","gz"])
ax2.set_ylim([-10,10])
ax2.grid(True)
ax2.set_ylabel("Velocidades angulares")

figure.suptitle("Labo. de Control - MPU6050", fontsize=20)

# nombre del archivo csv: output-<timestamp>.csv
timestr = time.strftime("%Y%m%d-%H%M%S")
with open("output"+timestr+".csv",'w') as file:
    writer = csv.writer(file, delimiter=',',lineterminator='\n')
    try: 
        ser = serial.Serial(PORT, BAUDRATE, timeout=2)
        print(f"Connected to serial port: {ser.portstr}")
        while True:
            #data = conn.recv(16) # tipos de datos en S7-1200: REAL (4 bytes), DInt (4 bytes)
            header_receive=0
            while header_receive<4:
                data_bytes=ser.read(1)
                # print(data_bytes)
                # print(header_receive)
                if header_receive==0 and data_bytes==b'a':
                    header_receive=1 
                elif header_receive==1 and data_bytes==b'b':
                    header_receive=2
                elif header_receive==2 and data_bytes==b'c':
                    header_receive=3
                elif header_receive==3 and data_bytes==b'd':
                    header_receive=4
                else:
                    header_receive=0
                    
            # print("header complete!")
            data_bytes = ser.read(24) # payload
            if not data_bytes:# or len(data_bytes) < 28:
                break
            # '<f' means little-endian floats. Use '>f' for big-endian.
            datareal_ax  = struct.unpack('<f',data_bytes[0:4])[0] # ax
            datareal_ay  = struct.unpack('<f',data_bytes[4:8])[0] # ay
            datareal_az  = struct.unpack('<f',data_bytes[8:12])[0] # az
            datareal_gx  = struct.unpack('<f',data_bytes[12:16])[0] # gx
            datareal_gy  = struct.unpack('<f',data_bytes[16:20])[0] # gy
            datareal_gz  = struct.unpack('<f',data_bytes[20:24])[0] # gz

            # verificamos los datos recibidos imprimiendo por linea de comandos
            # print(f"recibido: ax={datareal_ax} m/s2,\
            #                   ay={datareal_ay} m/s2,\
            #                   az={datareal_az} m/s2,\
            #                   gx={datareal_gx} °/s,\
            #                   gy={datareal_gy} °/s,\
            #                   gz={datareal_gz} °/s")
                            
                
            # desplaza los elementos de la lista y en la que guardamos las mediciones
            y = np.roll(y,-1,axis=1)
            # agregamos las nuevas lecturas recibidas
            y[:,-1] = [datareal_ax,datareal_ay,datareal_az,datareal_gx,datareal_gy,datareal_gz]
            # actualizamos los plots
            line11.set_xdata(x)
            line11.set_ydata(y[0,:])
            line12.set_xdata(x)
            line12.set_ydata(y[1,:])
            line13.set_xdata(x)
            line13.set_ydata(y[2,:])
            line21.set_xdata(x)
            line21.set_ydata(y[3,:])
            line22.set_xdata(x)
            line22.set_ydata(y[4,:])
            line23.set_xdata(x)
            line23.set_ydata(y[5,:])
            # dibuja los valores actualizados
            figure.canvas.draw()
            figure.canvas.flush_events()
                    
            # # escribe una linea en el archivo csv
            #writer.writerow(y[:,-1])
            writer.writerow([datareal_ax, datareal_ay, datareal_az, datareal_gx, datareal_gy, datareal_gz])
            
    except KeyboardInterrupt:
        print("Terminanding...")
    finally:
        # Cierra la conexión
        # conn.close()
        ser.close()
        print("Chaucha!")