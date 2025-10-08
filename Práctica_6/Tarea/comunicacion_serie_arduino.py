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
y = np.zeros((3,500)) # 6 variables: ax, ay, az, gx, gy, gz
x = np.arange(0,500)  # vector de indices para graficar: [0,...,1000]

# 
plt.ion()
 
# Crear la figura que vamos a ir actualizando con los datos
figure, (ax1) = plt.subplots(1,1,figsize=(10, 10))

# subfigura 1: ax, ay, az
line11, = ax1.plot(x, y[0,:], color='r', linewidth=0.6) # ax
ax1.legend(["position"])
ax1.set_ylim([-20,20])
ax1.grid(True)
ax1.set_ylabel("Posiciones")

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
            data_bytes = ser.read(4) # payload
            if not data_bytes:# or len(data_bytes) < 28:
                break
            # '<f' means little-endian floats. Use '>f' for big-endian.
            datareal_theta  = struct.unpack('<f',data_bytes[0:4])[0] # ax

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
            y[:,-1] = [datareal_theta]
            # actualizamos los plots
            line11.set_xdata(x)
            line11.set_ydata(y[0,:])
            # dibuja los valores actualizados
            figure.canvas.draw()
            figure.canvas.flush_events()
                    
            # # escribe una linea en el archivo csv
            #writer.writerow(y[:,-1])
            writer.writerow([datareal_theta])
            
    except KeyboardInterrupt:
        print("Terminanding...")
    finally:
        # Cierra la conexión
        # conn.close()
        ser.close()
        print("Chaucha!")