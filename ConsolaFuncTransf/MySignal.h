#ifndef MYSIGNAL_H
#define MYSIGNAL_H

#include <QVector>

class MySignal
{
private:
    QVector<float> data; // vector de datos
    int maxDataLength; // maxima longitud del vector de datos

public:
    MySignal();
    void Initialize(int i_maxLength); // inicializacion de la clase con i_maxLength numero maximo de datos
    void Shift(); // desplaza la tabla
    void SetActualValue(float new_value); // setea el valor actual a new_value
    const QVector<float>& GetData(); // devuelve todos los datos de la tabla en un vector
    float GetActualValue(); // devuelve el ultimo dato
};

#endif // MYSIGNAL_H
