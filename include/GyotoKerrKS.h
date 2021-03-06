/**
 *  \file GyotoKerrKS.h
 *  \brief KerrKS metric
 *
 *  Warning: this metric is seldom used and may be buggy.
 */

/*
    Copyright 2011-2015 Frederic Vincent, Thibaut Paumard

    This file is part of Gyoto.

    Gyoto is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Gyoto is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Gyoto.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef __GyotoKerrKS_H_
#define __GyotoKerrKS_H_ 

namespace Gyoto {
  namespace Metric { class KerrKS; }
}

#include <GyotoMetric.h>
#include <GyotoWorldline.h>
#ifdef GYOTO_USE_XERCES
#include <GyotoRegister.h>
#endif

/**
 * \class Gyoto::Metric::KerrKS
 * \brief Metric around a Kerr black-hole in Kerr-Schild coordinates
 *  Warning: this metric is seldom used and may be buggy.
 *
 * By default, uses the generic integrator
 * (Metric::Generic::myrk4()). Use
\code
<SpecificIntegrator/>
\endcode
 * to use the specific integretor which is, as of writting, buggy.
 */
class Gyoto::Metric::KerrKS
: public Metric::Generic
{
  friend class Gyoto::SmartPointer<Gyoto::Metric::KerrKS>;
  
  // Data : 
  // -----

 protected:
  double spin_ ;  ///< Angular momentum parameter
  double a2_;     ///< spin_*spin_
  double rsink_;  ///< numerical horizon
  double drhor_;  ///< horizon security

  // Constructors - Destructor
  // -------------------------
 public: 
  GYOTO_OBJECT;
  KerrKS(); ///< Default constructor
  virtual KerrKS* clone () const;         ///< Copy constructor
  
  // Mutators / assignment
  // ---------------------
 public:
  // default operator= is fine
  void spin(const double spin); ///< Set spin

  // Accessors
  // ---------
 public:
  double spin() const ; ///< Returns spin
  void horizonSecurity(double drhor);
  double horizonSecurity() const;
  
  double gmunu(const double x[4],
		       int alpha, int beta) const ;

  void gmunu(double g[4][4], const double pos[4]) const;

  /**
   *\brief The inverse matrix of gmunu
   */ 
  void gmunu_up(double gup[4][4], const double pos[4]) const;

  /**
   * \brief The derivatives of gmunu
   *
   * Used in the test suite
   */
  void jacobian(double dst[4][4][4], const double x[4]) const ;

  using Generic::christoffel;
  int christoffel(double dst[4][4][4], const double x[4]) const ;
  int christoffel(double dst[4][4][4], const double pos[4], double gup[4][4], double jac[4][4][4]) const ;

  virtual void circularVelocity(double const pos[4], double vel [4],
				double dir=1.) const ;

  virtual int isStopCondition(double const * const coord) const;

  virtual int setParameter(std::string name,
			   std::string content,
			   std::string unit);
};

#endif
