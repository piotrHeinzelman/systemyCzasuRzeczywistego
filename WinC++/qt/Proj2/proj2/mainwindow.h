#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QDialog>
#include <QLabel>
#include <QLineEdit>

QT_BEGIN_NAMESPACE
namespace Ui {
class MainWindow;
}
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();
    long calculateCRC( QString *data, long cyclesNum );

private slots:
    void on_pushButton_released();

private:
    Ui::MainWindow *ui;
    QPushButton *pushButton ;
    QLabel      *textCRC;
    QLabel      *textCycle;
    QLabel      *textTime;
    QLineEdit   *textline1;
    QLineEdit   *textline2;
    QString     *data;
    long         cycleNum;
};
 
#endif // MAINWINDOW_H
