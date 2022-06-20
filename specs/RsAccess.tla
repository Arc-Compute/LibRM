------------------------------ MODULE RsAccess ------------------------------
(*
    Copyright (C) 2022, 2666680 Ontario Inc.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*)
EXTENDS Naturals

-----------------------------------------------------------------------------

\* Access rights.
CONSTANTS
    AccessDupObject,                     \* Allows to duplicate the object.
    AccessNice,                          \* Allows to modify scheduling.
    AccessDebug                          \* Allows to allocate a debugger.
    
\* Right flags.
CONSTANTS
    AccessFlagNone,                      \* No access?
    AccessFlagAllowKernelPrivileged,     \* Lowest access, allows a kernel
                                         \* client to access it.
    AccessFlagAllowPrivileged,           \* Allows a privileged process to
                                         \* access the client.
    AccessFlagUncachedCheck,             \* Always check do not cache result.
    AccessFlagAllowOwner                 \* Unknown???
    
\* TODO: Confirm this is correct.
AccessMask ==
    { AccessDupObject
    , AccessNice
    , AccessDebug
    , AccessFlagNone
    , AccessFlagAllowKernelPrivileged
    , AccessFlagAllowPrivileged
    , AccessFlagUncachedCheck
    , AccessFlagAllowOwner
    }
    
\* Share access flags.
CONSTANTS
    AccessShareTypeNone,                 \* No sharing.
    AccessShareTypeAll,                  \* All can access this device.
    AccessShareTypeOsSecurityToken,      \* Client handles from the same UID
                                         \* can access this object.
    AccessShareTypeClient,               \* Share with specific client id.
    AccessShareTypePid,                  \* Shares with all clients from
                                         \* same PID.
    AccessShareTypeSmcPartition,         \* Shares with what shares the SMC
                                         \* partition.
    AccessShareTypeGpu,                  \* Shares with the physical gpu.
    AccessShareTypeFabricClient          \* Shares with fabric manager
                                         \* clients.

AccessShareTypes ==
    { AccessShareTypeNone
    , AccessShareTypeAll
    , AccessShareTypeOsSecurityToken
    , AccessShareTypeClient
    , AccessShareTypePid
    , AccessShareTypeSmcPartition
    , AccessShareTypeGpu
    , AccessShareTypeFabricClient
    }

(***************************************************************************)
(* Share actions.                                                          *)
(*                                                                         *)
(* Use Revoke to remove an existing policy from the list.                  *)
(*                                                                         *)
(* Allow is based on OR logic, Require is based on AND logic.              *)
(*                                                                         *)
(* To share a right, at least one Allow (non-Require) must match, and all  *)
(* Require must pass.                                                      *)
(*                                                                         *)
(* If Compose is specified, policies will be added to the list.            *)
(* Otherwise, they will replace the list.                                  *)
(*                                                                         *)
(***************************************************************************)
CONSTANTS
    AccessShareActionRevoke,             \* Revokes the share action.
    AccessShareActionRequire,            \* Requires the share action.
    AccessShareActionCompose             \* Composes the share action.
    
AccessShareActions ==
    { AccessShareActionRevoke
    , AccessShareActionRequire
    , AccessShareActionCompose
    }
    
RsSharePolicy ==
    [ target : Nat                       \* Target to share.
    , access : AccessMask                \* Access mask to apply.
    , type : AccessShareTypes            \* Type of share to use.
    , action : AccessShareActions        \* Actions to use.
    ]

=============================================================================
\* Modification History
\* Last modified Mon Jun 20 15:55:53 EDT 2022 by mbuchel
\* Created Mon Jun 20 11:06:37 EDT 2022 by mbuchel
