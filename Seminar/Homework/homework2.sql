SET SCHEMA FN000;

/* ALTER: */
ALTER TABLE AIRLINES
    ADD COLUMN CURRENCY CHAR(3);

ALTER TABLE FLIGHTS
    ADD COLUMN FLIGHT_CODE VARCHAR(4);

ALTER TABLE FLIGHTS
    ALTER COLUMN PAYMENT_SUM
      SET DATA TYPE DECIMAL(16,2);

ALTER TABLE BOOKINGS
    ADD COLUMN CUSTOMER_NAME VARCHAR(100);

ALTER TABLE BOOKINGS
    ADD COLUMN FCLASS SMALLINT DEFAULT 0;

ALTER TABLE BOOKINGS
    ADD CONSTRAINT FLASS_VALAIDITY_CONSTR
    CHECK (FCLASS IN (0,1));

/* TRIGGERS: : */
CREATE TRIGGER INSERT_BOOKINGS_ORDER_DATE_CHECK_TRIGGER
  BEFORE INSERT ON BOOKINGS
  REFERENCING NEW AS NEW_BOOKING
  FOR EACH ROW
  WHEN (NEW_BOOKING.ORDER_DATE > (SELECT FLIGHT_DATE
                                  FROM FLIGHTS
                                  WHERE FLIGHT_NUMBER = NEW_BOOKING.FLIGHT_NUMBER))
  BEGIN ATOMIC
    SIGNAL SQLSTATE '72011' ('Invalid order date!');
  END;

CREATE TRIGGER AFTER_INSERT_BOOKINGS_INCREASE_OCC_PAYMENT_TRIGGER
  AFTER INSERT ON BOOKINGS
  REFERENCING NEW AS NEW_BOOKING
  FOR EACH ROW
  BEGIN ATOMIC
    IF NEW_BOOKING.FCLASS = 0
    THEN
        UPDATE FLIGHTS
        SET OCC_ECON_CAP = OCC_ECON_CAP + 1,
            PAYMENT_SUM = PAYMENT_SUM + PRICE
        WHERE AIRLINE_CODE = NEW_BOOKING.AIRLINE_CODE
            AND FLIGHT_NUMBER = NEW_BOOKING.FLIGHT_NUMBER;
    ELSE
      UPDATE FLIGHTS
      SET OCC_BUSS_CAP = OCC_BUSS_CAP + 1,
        PAYMENT_SUM = PAYMENT_SUM + PRICE * 1.5
      WHERE AIRLINE_CODE = NEW_BOOKING.AIRLINE_CODE
            AND FLIGHT_NUMBER = NEW_BOOKING.FLIGHT_NUMBER;
      END IF;
  END;

CREATE TRIGGER AFTER_DELETE_BOOKINGS_DECREASE_OCC_PAYMENT_TRIGGER
  AFTER DELETE ON BOOKINGS
  REFERENCING OLD AS OLD_BOOKING
  FOR EACH ROW
  BEGIN ATOMIC
    IF OLD_BOOKING.FCLASS = 0
    THEN
      UPDATE FLIGHTS
      SET OCC_ECON_CAP = OCC_ECON_CAP - 1,
        PAYMENT_SUM = PAYMENT_SUM - PRICE
      WHERE AIRLINE_CODE = OLD_BOOKING.AIRLINE_CODE
            AND FLIGHT_NUMBER = OLD_BOOKING.FLIGHT_NUMBER;
    ELSE
      UPDATE FLIGHTS
      SET OCC_BUSS_CAP = OCC_BUSS_CAP - 1,
        PAYMENT_SUM = PAYMENT_SUM - PRICE * 1.5
      WHERE AIRLINE_CODE = OLD_BOOKING.AIRLINE_CODE
            AND FLIGHT_NUMBER = OLD_BOOKING.FLIGHT_NUMBER;
    END IF;
  END;

/* VIEWS: */
CREATE VIEW V_AIRLINE_FLIGHT ("AIRLINE NAME", "FLIGHT NUMBER", "FLIGHT DATE", "TICKET PRICE", "DEPARTURE LOCATION")
  AS SELECT A.NAME, F.FLIGHT_NUMBER, F.FLIGHT_DATE, F.PRICE, S.DEPT_CITY || ', ' || S.DEPT_COUNTRY
      FROM AIRLINES A, FLIGHTS F, SCHEDULES S
      WHERE A.CODE = F.AIRLINE_CODE
        AND F.FLIGHT_NUMBER = S.FLIGHT_NUMBER;

CREATE VIEW V_COMPANY_PAYMENT_SUM ("AIRLINE NAME", "NUMBER OF FLIGHTS", "TOTAL PAYMENT SUM")
  AS SELECT A.NAME, COUNT(DISTINCT B.FLIGHT_NUMBER), SUM(F.PAYMENT_SUM)
     FROM AIRLINES A, BOOKINGS B, FLIGHTS F
     WHERE A.CODE = B.AIRLINE_CODE
        AND B.FLIGHT_NUMBER = F.FLIGHT_NUMBER
    GROUP BY A.NAME;
