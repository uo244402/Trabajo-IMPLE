#ifndef DISCRETETF_H
#define DISCRETETF_H

#include <QObject>

class DiscreteTF
{
    private:
        QVector<float> b,a;
    public:
        DiscreteTF();
        bool Initialize(const QString& pol_b,const QString& pol_a);
        float Calc1Step(const QVector<float>& x,const QVector<float>& y);
};

#endif // DISCRETETF_H
