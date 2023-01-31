#include "DiscreteTF.h"

QVector<float> DiscreteTF::ExtractCoeff(QString _param_str, bool &ok) // se extraen los coeficientes de un string de formato [b0,b1,...,bn]
{
    QVector<float> coeff;

    if((!(_param_str.startsWith('[')))||(!(_param_str.endsWith(']')))){
        // si el formato no es valido, devuelve muchos ceros para que no funcione la ft
        ok = false;

        for(int i = 0; i<=5; i++){
            coeff.append(0);
        }

        return coeff;
    }

    else{
       // se eliminan los corchetes para evitar errores en la lista
       _param_str.remove(QChar('[')); _param_str.remove(QChar(']'));

       // se dividen en una lista de parametros por comas
       QStringList _param_list = _param_str.split(QLatin1Char(','));

       // se pasan a float cada uno de ellos y se guardan en la tabla b y a
       int size_param_list = _param_list.size();

       for(int i = 0; i<size_param_list; i++){
           coeff.append(_param_list[i].toFloat());
       }

       ok = true;

       return coeff;
    }
}

DiscreteTF::DiscreteTF()
{

}

bool DiscreteTF::Initialize(const QString &pol_b, const QString &pol_a)
{
    QString b_param_str = pol_b, a_param_str = pol_a; // se pasan a strings locales que podemos modificar
    bool ok = false; // variable para la validacion

    b = ExtractCoeff(b_param_str,ok); a = ExtractCoeff(a_param_str,ok); // extraccion de coeficientes

    m_b = b.size(); // tamaño de tabla de los coeficientes del numerador
    n_a = a.size(); // tamaño de tabla de los coeficientes del denominador

    if(!ok) return false;
    else return true;
}

float DiscreteTF::Calc1Step(const QVector<float> &in, const QVector<float> &out) // resuelve la ecuacion en diferencias
{
    float b_sum=0, a_sum=0;

    for(int i = 0; i<=m_b ; i++){ // se multiplican los coeficientes de b por la entrada
        b_sum += in[i]*b[i];
    }
    for(int i = 1; i<=n_a ; i++){ // se multiplican los coeficientes de a por la salida
        a_sum += out[i]*a[i];
    }

    float new_value = b_sum-a_sum; // se resuelve la ec. en diferencias y se saca un nuevo valor
    return new_value;
}
