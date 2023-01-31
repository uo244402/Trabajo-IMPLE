#include "DiscreteTF.h"
#include "MySignal.h"
#include <QCoreApplication>
#include <QFile>
#include <QThread>

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    MySignal torque_Nm,force_N,speedMotor_ms,positionMotor_m; // señales de entrada/salida
    DiscreteTF force2torque,speed2force,speed2pos; // funciones de transferencia discretizadas
    float wheel_diam=0.2, reduction=20; // parametros incializados (SI)
    QString params_xml;
    //Leer params_xml de archivo "params.xml"
    //wheel_diam=XmlGetFloat(params_xml,"WheelDiam_mm")/1000.0;

    // Se inicializan las fts con los coeficientes de transferencia en formato "[b0,b1,...,bm]","[a0,a1,...an]"
    force2torque.Initialize("[100]","[0]"); // Coefs personalizados para cada Fj
    speed2force.Initialize("[3333.83,-3332.83]","[1,1]");
    speed2pos.Initialize("[0.0075,0.0075]","[1,-1]");

    // Inicializar señales según el tamaño requerido:
    torque_Nm.Initialize(2);
    force_N.Initialize(2);
    speedMotor_ms.Initialize(2);
    positionMotor_m.Initialize(2);

    QFile input("input.txt"),output("output.txt");
    input.open(QIODevice::ReadOnly);
    output.open(QIODevice::WriteOnly);
    QString lineIn,lineOut;

    while (input.canReadLine())
    {
        // PROCESAMIENTO
        // se avanza un instante en las tablas (se desplazan las tablas)
        torque_Nm.Shift(), force_N.Shift(), speedMotor_ms.Shift(), positionMotor_m.Shift();

        // se lee el siguiente dato del fichero
        lineIn = input.readLine();

        // se coloca como valor actual de la señal de entrada
        speedMotor_ms.SetActualValue(lineIn.toFloat());

        // se calculan el valor de salida de cada una de las funciones de transferencia
        force_N.SetActualValue(speed2force.Calc1Step(speedMotor_ms.GetData(),force_N.GetData()));
        torque_Nm.SetActualValue(force2torque.Calc1Step(force_N.GetData(),torque_Nm.GetData()));
        positionMotor_m.SetActualValue(speed2pos.Calc1Step(speedMotor_ms.GetData(),positionMotor_m.GetData()));

        // se crea linea de salida con todos los valores obtenidos para meterlos a fichero (con comas para formato .csv)
        lineOut = QString::number(force_N.GetActualValue()) + "," + QString::number(torque_Nm.GetActualValue()) + "," + QString::number(positionMotor_m.GetActualValue()) + "\n";
        output.write(lineOut.toLatin1());
        QThread::msleep(5);
    }

    return a.exec();
}
