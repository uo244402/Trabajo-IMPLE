#include "DiscreteTF.h"

DiscreteTF::DiscreteTF()
{

}

bool DiscreteTF::Initialize(const QString &pol_b, const QString &pol_a)
{
    QString b_param_str = pol_b, a_param_str = pol_a;

    // nos aseguramos de que empezamos con corchetes
    if((!(b_param_str.startsWith('[')))||(!(a_param_str.startsWith('[')))){
        return false;
    }
    else if((!(b_param_str.endsWith(']')))||(!(a_param_str.startsWith(']')))){
        return false;
    }
    else{
       //falta eliminar los corchetes
       // se dividen en una lista de parametros por comas
       QStringList b_param_list = b_param_str.split(QLatin1Char(','));
       QStringList a_param_list = b_param_str.split(QLatin1Char(','));
       // se pasan a float cada uno de ellos y se guardan en la tabla b y a
       for(int i = 0; i<=b_param_list.size(); i++){
           b[i] = b_param_list[i].toFloat();
       }

       return true;
    }

}
