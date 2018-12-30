#!/usr/bin/env python3
# -------------------------------------------------------------------------------------------------
# <copyright file="events.pxd" company="Invariance Pte">
#  Copyright (C) 2018-2019 Invariance Pte. All rights reserved.
#  The use of this source code is governed by the license as found in the LICENSE.md file.
#  http://www.invariance.com
# </copyright>
# -------------------------------------------------------------------------------------------------

# cython: language_level=3, boundscheck=False, wraparound=False

from cpython.datetime cimport datetime

from inv_trader.model.objects cimport Symbol
from inv_trader.model.identifiers cimport GUID, Label, AccountId, AccountNumber
from inv_trader.model.identifiers cimport OrderId, ExecutionId, ExecutionTicket


cdef class Event:
    """
    The abstract base class for all events.
    """
    cdef readonly GUID id
    cdef readonly datetime timestamp


cdef class AccountEvent(Event):
    """
    Represents an account event produced from a collateral report.
    """
    cdef readonly AccountId account_id
    cdef readonly object broker
    cdef readonly AccountNumber account_number
    cdef readonly object currency
    cdef readonly object cash_balance
    cdef readonly object cash_start_day
    cdef readonly object cash_activity_day
    cdef readonly object margin_used_liquidation
    cdef readonly object margin_used_maintenance
    cdef readonly object margin_ratio
    cdef readonly str margin_call_status


cdef class OrderEvent(Event):
    """
    The abstract base class for all order events.
    """
    cdef readonly Symbol symbol
    cdef readonly OrderId order_id


cdef class OrderSubmitted(OrderEvent):
    """
    Represents an event where an order has been submitted to the execution system.
    """
    cdef readonly datetime submitted_time


cdef class OrderAccepted(OrderEvent):
    """
    Represents an event where an order has been accepted by the broker.
    """
    cdef readonly datetime accepted_time


cdef class OrderRejected(OrderEvent):
    """
    Represents an event where an order has been rejected by the broker.
    """
    cdef readonly datetime rejected_time
    cdef readonly str rejected_reason


cdef class OrderWorking(OrderEvent):
    """
    Represents an event where an order is working with the broker.
    """
    cdef readonly OrderId broker_order_id
    cdef readonly Label label
    cdef readonly object order_side
    cdef readonly object order_type
    cdef readonly int quantity
    cdef readonly object price
    cdef readonly object time_in_force
    cdef readonly datetime working_time
    cdef readonly datetime expire_time


cdef class OrderCancelled(OrderEvent):
    """
    Represents an event where an order has been cancelled with the broker.
    """
    cdef readonly datetime cancelled_time


cdef class OrderCancelReject(OrderEvent):
    """
    Represents an event where an order cancel request has been rejected by the broker.
    """
    cdef readonly datetime cancel_reject_time
    cdef readonly str cancel_reject_response
    cdef readonly str cancel_reject_reason


cdef class OrderExpired(OrderEvent):
    """
    Represents an event where an order has expired with the broker.
    """
    cdef readonly datetime expired_time


cdef class OrderModified(OrderEvent):
    """
    Represents an event where an order has been modified with the broker.
    """
    cdef readonly OrderId broker_order_id
    cdef readonly object modified_price
    cdef readonly datetime modified_time


cdef class OrderFilled(OrderEvent):
    """
    Represents an event where an order has been completely filled with the broker.
    """
    cdef readonly ExecutionId execution_id
    cdef readonly ExecutionTicket execution_ticket
    cdef readonly object order_side
    cdef readonly object filled_quantity
    cdef readonly object average_price
    cdef readonly datetime execution_time


cdef class OrderPartiallyFilled(OrderEvent):
    """
    Represents an event where an order has been partially filled with the broker.
    """
    cdef readonly ExecutionId execution_id
    cdef readonly ExecutionTicket execution_ticket
    cdef readonly object order_side
    cdef readonly object filled_quantity
    cdef readonly object leaves_quantity
    cdef readonly object average_price
    cdef readonly datetime execution_time


cdef class TimeEvent(Event):
    """
    Represents a time event occurring at the event timestamp.
    """
    cdef readonly Label label