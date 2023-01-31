#ifndef DISCRETETF_H
#define DISCRETETF_H

#include <QObject>

class DiscreteTF
{
    private:
        QVector<float> b,a; // coeficientes funcion de transferencia
        float m_b,n_a; // tamaño maximo de las tablas de coeficientes

        // metodos privados
        QVector<float> ExtractCoeff(QString _param_str, bool &ok);

    public:
        DiscreteTF();
        bool Initialize(const QString& pol_b,const QString& pol_a);
        float Calc1Step(const QVector<float>& in, const QVector<float>& out);
};

#endif // DISCRETETF_H
