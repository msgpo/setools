# Copyright 2017-2018, Chris PeBenito <pebenito@ieee.org>
# Derived from netcontext.py
#
# This file is part of SETools.
#
# SETools is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation, either version 2.1 of
# the License, or (at your option) any later version.
#
# SETools is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with SETools.  If not, see
# <http://www.gnu.org/licenses/>.
#
from collections import namedtuple

IomemconRange = namedtuple("IomemconRange", ["low", "high"])
IoportconRange = namedtuple("IoportconRange", ["low", "high"])


#
# Devicetreecon factory functions
#
cdef inline Devicetreecon devicetreecon_factory(SELinuxPolicy policy, sepol.ocontext_t *symbol):
    """Factory function for creating Devicetreecon objects."""
    d = Devicetreecon()
    d.policy = policy
    d.handle = symbol
    return d


cdef inline devicetreecon_iterator_factory(SELinuxPolicy policy, sepol.ocontext_t *head):
    """Factory function for creating Devicetreecon iterators."""
    i = DevicetreeconIterator()
    i.policy = policy
    i.head = i.curr = head
    return i


#
# Iomemcon factory functions
#
cdef inline Iomemcon iomemcon_factory(SELinuxPolicy policy, sepol.ocontext_t *symbol):
    """Factory function for creating Iomemcon objects."""
    i = Iomemcon()
    i.policy = policy
    i.handle = symbol
    return i


cdef inline iomemcon_iterator_factory(SELinuxPolicy policy, sepol.ocontext_t *head):
    """Factory function for creating Iomemcon iterators."""
    i = IomemconIterator()
    i.policy = policy
    i.head = i.curr = head
    return i


#
# Ioportcon factory functions
#
cdef inline Ioportcon ioportcon_factory(SELinuxPolicy policy, sepol.ocontext_t *symbol):
    """Factory function for creating Ioportcon objects."""
    i = Ioportcon()
    i.policy = policy
    i.handle = symbol
    return i


cdef inline ioportcon_iterator_factory(SELinuxPolicy policy, sepol.ocontext_t *head):
    """Factory function for creating Ioportcon iterators."""
    i = IoportconIterator()
    i.policy = policy
    i.head = i.curr = head
    return i


#
# Pcidevicecon factory functions
#
cdef inline Pcidevicecon pcidevicecon_factory(SELinuxPolicy policy, sepol.ocontext_t *symbol):
    """Factory function for creating Pcidevicecon objects."""
    p = Pcidevicecon()
    p.policy = policy
    p.handle = symbol
    return p


cdef inline pcidevicecon_iterator_factory(SELinuxPolicy policy, sepol.ocontext_t *head):
    """Factory function for creating Pcidevicecon iterators."""
    i = PcideviceconIterator()
    i.policy = policy
    i.head = i.curr = head
    return i


#
# Pirqcon factory functions
#
cdef inline Pirqcon pirqcon_factory(SELinuxPolicy policy, sepol.ocontext_t *symbol):
    """Factory function for creating Pirqcon objects."""
    p = Pirqcon()
    p.policy = policy
    p.handle = symbol
    return p


cdef inline pirqcon_iterator_factory(SELinuxPolicy policy, sepol.ocontext_t *head):
    """Factory function for creating Pirqcon iterators."""
    i = PirqconIterator()
    i.policy = policy
    i.head = i.curr = head
    return i


#
# Classes
#
cdef class Devicetreecon(Ocontext):

    """A devicetreecon statement."""

    def __str__(self):
        return "devicetreecon {0.path} {0.context}".format(self)

    @property
    def path(self):
        """
        The path for this devicetreecon.

        Return: The device path name.
        """
        return intern(self.handle.u.name)


cdef class DevicetreeconIterator(OcontextIterator):

    """Iterator for devicetreecon statements in the policy."""

    def __next__(self):
        super().__next__()
        return devicetreecon_factory(self.policy, self.ocon)


cdef class Iomemcon(Ocontext):

    """A iomemcon statement."""

    def __str__(self):
        low, high = self.addr

        if low == high:
            return "iomemcon {0} {1}".format(low, self.context)
        else:
            return "iomemcon {0}-{1} {2}".format(low, high, self.context)

    @property
    def addr(self):
        """
        The memory range for this iomemcon.

        Return: Tuple(low, high)
        low     The low memory of the range.
        high    The high memory of the range.
        """
        return IomemconRange(self.handle.u.iomem.low_iomem,
                             self.handle.u.iomem.high_iomem)


cdef class IomemconIterator(OcontextIterator):

    """Iterator for iomemcon statements in the policy."""

    def __next__(self):
        super().__next__()
        return iomemcon_factory(self.policy, self.ocon)


cdef class Ioportcon(Ocontext):

    """A ioportcon statement."""

    def __str__(self):
        low, high = self.ports

        if low == high:
            return "ioportcon {0} {1}".format(low, self.context)
        else:
            return "ioportcon {0}-{1} {2}".format(low, high, self.context)

    @property
    def ports(self):
        """
        The port range for this ioportcon.

        Return: Tuple(low, high)
        low     The low port of the range.
        high    The high port of the range.
        """
        return IoportconRange(self.handle.u.ioport.low_ioport,
                              self.handle.u.ioport.high_ioport)


cdef class IoportconIterator(OcontextIterator):

    """Iterator for ioportcon statements in the policy."""

    def __next__(self):
        super().__next__()
        return ioportcon_factory(self.policy, self.ocon)


cdef class Pcidevicecon(Ocontext):

    """A pcidevicecon statement."""

    def __str__(self):
        return "pcidevicecon {0.device} {0.context}".format(self)

    @property
    def device(self):
        """
        The device for this pcidevicecon.

        Return: The PCI device ID.
        """
        return self.handle.u.device


cdef class PcideviceconIterator(OcontextIterator):

    """Iterator for pcidevicecon statements in the policy."""

    def __next__(self):
        super().__next__()
        return pcidevicecon_factory(self.policy, self.ocon)


cdef class Pirqcon(Ocontext):

    """A pirqcon statement."""

    def __str__(self):
        return "pirqcon {0.irq} {0.context}".format(self)

    @property
    def irq(self):
        """
        The irq for this pirqcon.

        Return: The irq.
        """
        return self.handle.u.pirq


cdef class PirqconIterator(OcontextIterator):

    """Iterator for pirqcon statements in the policy."""

    def __next__(self):
        super().__next__()
        return pirqcon_factory(self.policy, self.ocon)
