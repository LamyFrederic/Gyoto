%module gyoto

%define GYOTO_SWIGIMPORTED
%enddef

%{
#define SWIG_FILE_WITH_INIT
  //#define NPY_NO_DEPRECATED_API NPY_1_7_API_VERSION
#include "Python.h"
#define GYOTO_NO_DEPRECATED
#include "GyotoConfig.h"
#include "GyotoFactory.h"
#include "GyotoValue.h"
#include "GyotoProperty.h"
#include "GyotoObject.h"
#include "GyotoAstrobj.h"
#include "GyotoError.h"
#include "GyotoWorldline.h"
#include "GyotoPhoton.h"
#include "GyotoScreen.h"
using namespace Gyoto;
Gyoto::SmartPointer<Gyoto::Metric::Generic> pyGyotoMetric(std::string const&);
Gyoto::SmartPointer<Gyoto::Astrobj::Generic> pyGyotoAstrobj(std::string const&);
Gyoto::SmartPointer<Gyoto::Spectrum::Generic> pyGyotoSpectrum(std::string const&);
Gyoto::SmartPointer<Gyoto::Spectrometer::Generic> pyGyotoSpectrometer(std::string const&);
void pyGyotoErrorHandler (const Gyoto::Error e) {
  std::cerr << "GYOTO error: "<<e<<std::endl;
  PyErr_SetString(PyExc_RuntimeError, e);
  return;
}

%}




%include "std_string.i" 
%include "std_vector.i"
%template(vector_double) std::vector<double>;
%template(vector_unsigned_long) std::vector<unsigned long>;
%include "carrays.i"
%array_class(double, array_double)
%include "numpy.i"

%include "GyotoError.h"

%init {
  Gyoto::Error::setHandler(&pyGyotoErrorHandler);
  Gyoto::Register::init();
  import_array();
 }

%ignore Gyoto::SmartPointee;
%include "GyotoSmartPointer.h"

%include "GyotoValue.h"
%include "GyotoObject.h"

%template(ScreenPtr) Gyoto::SmartPointer<Gyoto::Screen>;
%include "GyotoScreen.h"

%ignore Gyoto::Worldline::IntegState;
%ignore Gyoto::Worldline::IntegState::Generic;
%ignore Gyoto::Worldline::IntegState::Boost;
%ignore Gyoto::Worldline::IntegState::Legacy;
%include "GyotoWorldline.h"

%rename (castToWorldline) pyGyotoCastToWorldline;
%inline %{
Gyoto::Worldline * pyGyotoCastToWorldline
  (Gyoto::SmartPointer<Gyoto::Astrobj::Generic> const_p) {
  Gyoto::SmartPointee * p=const_cast<Gyoto::Astrobj::Generic*>(const_p());
  Gyoto::Worldline * res = dynamic_cast<Gyoto::Worldline*>(p);
  return res;
}
%}

%template(PhotonPtr) Gyoto::SmartPointer<Gyoto::Photon>;
%include "GyotoPhoton.h"

%template(AstrobjPtr) Gyoto::SmartPointer<Gyoto::Astrobj::Generic>;
%ignore Gyoto::Astrobj::Generic;
%ignore Gyoto::Astrobj::Register_;
%ignore Gyoto::Astrobj::Register;
%ignore Gyoto::Astrobj::initRegister;
%ignore Gyoto::Astrobj::getSubcontractor;

%include "GyotoAstrobj.h"

%define _PAccessor(member, setter)
  void setter(double *IN_ARRAY2, int DIM1, int DIM2) {
    $self->member = IN_ARRAY2;
  }
%enddef

%extend Gyoto::Astrobj::Properties{
  _PAccessor(intensity, Intensity)
  _PAccessor(binspectrum, BinSpectrum)
  _PAccessor(distance, MinDistance)
  _PAccessor(first_dmin, FirstDistMin)
  _PAccessor(impactcoords, ImpactCoords)
  _PAccessor(redshift, Redshift)
  _PAccessor(spectrum, Spectrum)
  _PAccessor(time, EmissionTime)
  _PAccessor(user1, User1)
  _PAccessor(user2, User2)
  _PAccessor(user3, User3)
  _PAccessor(user4, User4)
  _PAccessor(user5, User5)
 };

Gyoto::SmartPointer<Gyoto::Astrobj::Generic> pyGyotoAstrobj(std::string const&);

%template(MetricPtr) Gyoto::SmartPointer<Gyoto::Metric::Generic>;
%ignore Gyoto::Metric::Generic;
%ignore Gyoto::Metric::Register_;
%ignore Gyoto::Metric::Register;
%ignore Gyoto::Metric::initRegister;
%ignore Gyoto::Metric::getSubcontractor;
%include "GyotoMetric.h"
%rename(Metric) pyGyotoMetric;
Gyoto::SmartPointer<Gyoto::Metric::Generic> pyGyotoMetric(std::string const&);

%template(SpectrumPtr) Gyoto::SmartPointer<Gyoto::Spectrum::Generic>;
%ignore Gyoto::Spectrum::Generic;
%ignore Gyoto::Spectrum::Register_;
%ignore Gyoto::Spectrum::Register;
%ignore Gyoto::Spectrum::initRegister;
%ignore Gyoto::Spectrum::getSubcontractor;
%include "GyotoSpectrum.h"
%rename(Spectrum) pyGyotoSpectrum;
Gyoto::SmartPointer<Gyoto::Spectrum::Generic> pyGyotoSpectrum(std::string const&);

%template(SpectrometerPtr) Gyoto::SmartPointer<Gyoto::Spectrometer::Generic>;
%ignore Gyoto::Spectrometer::Generic;
%ignore Gyoto::Spectrometer::Register_;
%ignore Gyoto::Spectrometer::Register;
%ignore Gyoto::Spectrometer::initRegister;
%ignore Gyoto::Spectrometer::getSubcontractor;
%include "GyotoSpectrometer.h"
%rename(Spectrometer) pyGyotoSpectrometer;
Gyoto::SmartPointer<Gyoto::Spectrometer::Generic> pyGyotoSpectrometer(std::string const&);


%include "GyotoConfig.h"
%include "GyotoDefs.h"
%include "GyotoUtils.h"
%include "GyotoFactory.h"

 // SWIG fails on nested classes. Work around this limitation:
%{
  typedef Gyoto::Screen::CoordType_e CoordType_e;
  typedef Gyoto::Screen::Coord1dSet Coord1dSet;
  typedef Gyoto::Screen::Coord2dSet Coord2dSet;
  typedef Gyoto::Screen::Grid Grid;
  typedef Gyoto::Screen::Bucket Bucket;
  typedef Gyoto::Screen::Empty Empty;
  typedef Gyoto::Screen::Range Range;
  typedef Gyoto::Screen::Indices Indices;
  typedef Gyoto::Screen::Angles Angles;
  typedef Gyoto::Screen::RepeatAngle RepeatAngle;
%}

enum CoordType_e;

class Coord1dSet {
public:
  const CoordType_e kind;
public:
  Coord1dSet(CoordType_e k);
  virtual void begin() =0;
  virtual bool valid() =0;
  virtual size_t size()=0;
  virtual size_t operator*() const ;
  virtual double angle() const ;
  virtual Coord1dSet& operator++()=0;
};

class Coord2dSet {
public:
  const CoordType_e kind;
  Coord2dSet(CoordType_e k);
  virtual Coord2dSet& operator++()    =0;
  virtual GYOTO_ARRAY<size_t, 2> operator*  () const;
  virtual GYOTO_ARRAY<double, 2> angles() const ;
  virtual void begin() =0;
  virtual bool valid() =0;
  virtual size_t size()=0;
};

class Grid: public Coord2dSet {
protected:
protected:
  const char * const prefix_;
  Coord1dSet &iset_;
  Coord1dSet &jset_;
public:
  Grid(Coord1dSet &iset, Coord1dSet &jset, const char * const p=NULL);
  virtual Coord2dSet& operator++();
  virtual GYOTO_ARRAY<size_t, 2> operator*  () const;
  virtual void begin();
  virtual bool valid();
  virtual size_t size();
};

class Bucket : public Coord2dSet {
protected:
  Coord1dSet &alpha_;
  Coord1dSet &delta_;
public:
  Bucket(Coord1dSet &iset, Coord1dSet &jset);
  virtual Coord2dSet& operator++();
  virtual GYOTO_ARRAY<double, 2> angles() const;
  virtual GYOTO_ARRAY<size_t, 2> operator*() const;
  virtual void begin();
  virtual bool valid();
  virtual size_t size();
};

class Empty: public Coord2dSet {
public:
  Empty();
  virtual Coord2dSet& operator++();
  virtual void begin();
  virtual bool valid();
  virtual size_t size();
};

class Range : public Coord1dSet {
protected:
  const size_t mi_, ma_, d_, sz_;
  size_t cur_;
public:
  Range(size_t mi, size_t ma, size_t d);
  void begin();
  bool valid();
  size_t size();
  Coord1dSet& operator++();
  size_t operator*() const ;
};

class Indices : public Coord1dSet {
protected:
  size_t const * const indices_;
  size_t const sz_;
  size_t i_;
public:
  Indices (unsigned long * IN_ARRAY1, unsigned long DIM1);
  void begin();
  bool valid();
  size_t size();
  Coord1dSet& operator++();
  size_t operator*() const ;
};

class Angles : public Coord1dSet {
protected:
  double const * const buf_;
  size_t const sz_;
  size_t i_;
public:
  Angles (double const*const buf, size_t sz);
  void begin();
  bool valid();
  size_t size();
  Coord1dSet& operator++();
  double angle() const ;
};

class RepeatAngle : public Coord1dSet {
protected:
  double const val_;
  size_t const sz_;
  size_t i_;
public:
  RepeatAngle (double val, size_t sz);
  void begin();
  bool valid();
  size_t size();
  Coord1dSet& operator++();
  double angle() const ;
};

%template(SceneryPtr) Gyoto::SmartPointer<Gyoto::Scenery>;
%include "GyotoScenery.h"
