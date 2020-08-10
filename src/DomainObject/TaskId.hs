module DomainObject.TaskId (TaskId (..), fromText) where

import Essential
import qualified Data.Text as T

newtype TaskId = TaskId Text
  deriving newtype (Eq)

fromText :: Text -> TaskId
fromText = TaskId . T.toLower

instance Show TaskId where
  show (TaskId taskId) = convertString taskId
