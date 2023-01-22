/*

Cleaning Data in SQL Queries

*/


Select *
From portfolio1.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

select saledate, convert(date, saledate) as salesdate from portfolio1.dbo.NashvilleHousing

Update portfolio1.dbo.NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

alter table portfolio1.dbo.NashvilleHousing
add saledatecov Date;

update portfolio1.dbo.NashvilleHousing
set saledatecov = convert(date, saledate)
 --check
select * from portfolio1.dbo.NashvilleHousing



 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

select * from portfolio1.dbo.NashvilleHousing
--where propertyaddress is null
order by parcelid


select a.uniqueid, a.parcelid, a.propertyaddress, b.uniqueid, b.parcelid, b.propertyaddress 
, ISNULL(a.propertyaddress, b.propertyaddress) as Finalpropertyaddress
from portfolio1.dbo.NashvilleHousing a
join portfolio1.dbo.NashvilleHousing b
on a.parcelid = b.parcelid
and a.uniqueid <> b.uniqueid
where a.propertyaddress is null

update a
set propertyaddress = ISNULL(a.propertyaddress, b.propertyaddress)
from portfolio1.dbo.NashvilleHousing a
join portfolio1.dbo.NashvilleHousing b
on a.parcelid = b.parcelid
and a.uniqueid <> b.uniqueid
where a.propertyaddress is null

select * from portfolio1.dbo.NashvilleHousing





--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From portfolio1.dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

select
substring(propertyaddress, 1, charindex(',' , propertyaddress)-1) as address , 
substring( propertyaddress, charindex(',' , propertyaddress)+1 , len(propertyaddress)) as city
From portfolio1.dbo.NashvilleHousing

ALTER TABLE portfolio1.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update portfolio1.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE portfolio1.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update portfolio1.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From portfolio1.dbo.NashvilleHousing





Select OwnerAddress
From portfolio1.dbo.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From portfolio1.dbo.NashvilleHousing



ALTER TABLE portfolio1.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update portfolio1.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE portfolio1.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update portfolio1.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE portfolio1.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update portfolio1.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From portfolio1.dbo.NashvilleHousing




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From portfolio1.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From portfolio1.dbo.NashvilleHousing


Update portfolio1.dbo.NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From portfolio1.dbo.NashvilleHousing
--order by ParcelID
)
Delete
From RowNumCTE
Where row_num > 1

--check
select *
From RowNumCTE
Where row_num > 1



Select *
From portfolio1.dbo.NashvilleHousing




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From portfolio1.dbo.NashvilleHousing


ALTER TABLE portfolio1.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


-- cleaned Data
Select *
From portfolio1.dbo.NashvilleHousing













-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

















