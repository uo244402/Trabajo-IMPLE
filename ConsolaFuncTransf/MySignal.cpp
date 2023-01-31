#include "MySignal.h"

MySignal::MySignal()
{

}

void MySignal::Initialize(int i_maxLength) // inicializa todos los datos de la tabla para el tamaño requerido
{
    maxDataLength = i_maxLength;

    for(int i = 0; i <= maxDataLength; i++){
        data.append(0);
    }
}

void MySignal::Shift() // desplaza todos los valores una posicion
{
    for(int i = 0; i < maxDataLength; i++){
        data[i+1] = data[i];
    }
}

void MySignal::SetActualValue(float new_value)
{
    data[0] = new_value;
}

const QVector<float> &MySignal::GetData()
{
    return data;
}

float MySignal::GetActualValue()
{
    return data[0];
}
